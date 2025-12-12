---
name: gitlab-ci
description: GitLab CI/CD pipelines with Ansible, Hetzner dynamic runners, and persistent Storage Box cache.
---

# GitLab CI/CD Skill

## РЕКОМЕНДАЦИЯ: Ansible вместо Bash heredoc

Для сложных CI pipeline используй **Ansible playbook** вместо bash heredoc. Это избавляет от проблем с экранированием переменных.

### Почему Ansible лучше

| Подход | Проблемы |
|--------|----------|
| Bash heredoc | Нужно следить за `<< EOF` vs `<< 'EOF'`, экранировать `\$` для локальных переменных |
| Ansible | `lookup('env', 'VAR')` работает всегда, никакого экранирования |

### Паттерн: Ansible в GitLab CI

```yaml
script:
  # Inventory БЕЗ кавычек - $RUNNER_IP нужна интерполяция
  - |
    cat > inventory.yml << EOF
    all:
      hosts:
        ci_runner:
          ansible_host: $RUNNER_IP
          ansible_user: root
    EOF

  # Playbook С кавычками - Ansible использует lookup('env')
  - |
    cat > playbook.yml << 'PLAYBOOK_EOF'
    ---
    - name: CI Pipeline
      hosts: ci_runner
      vars:
        ci_repository_url: "{{ lookup('env', 'CI_REPOSITORY_URL') }}"
        ci_commit_ref_name: "{{ lookup('env', 'CI_COMMIT_REF_NAME') }}"
      tasks:
        - name: Clone repo
          ansible.builtin.git:
            repo: "{{ ci_repository_url }}"
            dest: /app
            version: "{{ ci_commit_ref_name }}"
    PLAYBOOK_EOF

  - ansible-playbook -i inventory.yml playbook.yml
```

### Версии (Alpine apk add ansible)

- ansible-core: 2.20.0
- community.docker: 5.0.1

### Модули community.docker

```yaml
# Docker login
- community.docker.docker_login:
    registry_url: "registry.example.com"
    username: "{{ ci_registry_user }}"
    password: "{{ ci_registry_password }}"

# Pull/build image
- community.docker.docker_image:
    name: "{{ ci_image }}"
    source: pull  # или build

# Run container
- community.docker.docker_container:
    name: "openproject-ci"
    image: "{{ ci_image }}"
    state: started
    command: sleep infinity
    volumes:
      - "/mnt/ci-cache/app:/app"
      - "/mnt/ci-cache/bundle:/usr/local/bundle"

# Exec in container
- community.docker.docker_container_exec:
    container: "openproject-ci"
    command: /app/docker/ci/entrypoint.sh run-units
```

---

## LEGACY: Heredoc Variable Interpolation

Если всё же используешь bash heredoc:

| Heredoc Syntax | Variable Interpolation | Use Case |
|----------------|----------------------|----------|
| `<< EOF` | YES | Need GitLab CI variables |
| `<< 'EOF'` | NO | All variables are local |

**Мнемоника:** Quotes = Quarantine (кавычки изолируют от внешних переменных)

---

## Project Structure

```
ci-templates/                    # Shared CI templates
├── .gitlab-ci.yml              # Base pipeline with Hetzner runners
└── docker/Dockerfile.runner    # CI runner image (Alpine + ansible)

my-OpenProject/
├── .gitlab-ci.yml              # Ansible playbook для тестов
└── docker/ci/
    ├── Dockerfile              # Test image
    └── entrypoint.sh           # Test runner
```

## Hetzner Dynamic Runners

1. **pre-cleanup**: Удаляет orphan VM старше 30 мин
2. **provision**: Creates ephemeral ccx63 VM with Storage Box mount
3. **test**: Runs Ansible playbook on VM
4. **cleanup**: Destroys VM (always runs)

## Storage Box Cache (Persistent)

```
/mnt/ci-cache/
├── app/                   # Source code with .git (clone once, fetch always)
├── bundle/                # Ruby gems
├── node_modules/          # Root node_modules
├── frontend_node_modules/ # Frontend node_modules
├── angular/               # Angular build cache
├── buildx/                # Docker buildx layer cache
└── runtime-logs/          # Test timing logs
```

Mount via CIFS in cloud-init:
```yaml
mount.cifs -o user=${USER},pass=${PASS},seal,uid=1000,gid=1000 \
  //${USER}.your-storagebox.de/${USER} /mnt/ci-cache
```

**ВАЖНО:** Для субаккаунтов путь `//${USER}.your-storagebox.de/${USER}`, НЕ `/backup`!

## Common Variables

```yaml
variables:
  SERVER_TYPE: "ccx63"
  CI_REGISTRY_IMAGE: "registry.example.com/project/ci"
  CI_JOBS: "48"
  CI_RETRY_COUNT: "4"
```

---

## Accessing Test Logs

Test logs are available in 2 locations:

### 1. GitLab Artifacts (Recommended - Persists 1 week)

```bash
# Must be in project directory
cd ~/Projects/my-OpenProject
export GITLAB_HOST=gl.andrianoff.online

# Download test artifacts
glab job artifact <branch> test --path="/tmp/ci-artifacts/"

# Example
glab job artifact fix/enterprise-bypass-feature-tests test --path="/tmp/ci-artifacts/"

# View downloaded logs
cat /tmp/ci-artifacts/test-results/rspec-output.log
cat /tmp/ci-artifacts/test-results/runtime-logs/turbo_runtime_units.log
cat /tmp/ci-artifacts/test-results/runtime-logs/op-output.log
```

**Artifact contents:**
| File | Description |
|------|-------------|
| `rspec-output.log` | Full RSpec test output with dots/failures |
| `runtime-logs/turbo_runtime_units.log` | Test timing data (spec → time) |
| `runtime-logs/op-output.log` | Setup/migration output |

### 2. Runner VM (During/After Pipeline)

VM is **persistent** (ci-runner-my-openproject), logs remain until next pipeline:

```bash
# Get runner IP from hcloud
export BW_SESSION="..."  # from `bw unlock`
HCLOUD_TOKEN=$(bw get password "HetznerAPI-token")
export HCLOUD_TOKEN
RUNNER_IP=$(hcloud server list -o json | jq -r '.[] | select(.name | contains("ci-runner")) | .public_net.ipv4.ip')

# Get SSH key from Bitwarden (add trailing newline!)
bw get notes "CI_SSH_PRIVATE_KEY" > /tmp/ci_key
echo "" >> /tmp/ci_key
chmod 600 /tmp/ci_key

# SSH with IdentitiesOnly to prevent key cycling
ssh -o 'IdentitiesOnly yes' -o 'StrictHostKeyChecking no' -i /tmp/ci_key root@$RUNNER_IP

# Logs on runner
cat /home/ciuser/app/rspec-output.log
cat /home/ciuser/app/cache/runtime-logs/turbo_runtime_units.log
cat /home/ciuser/app/cache/runtime-logs/op-output.log
```

**Log locations on runner:**
| Path | Description |
|------|-------------|
| `/home/ciuser/app/rspec-output.log` | Main test output (local disk) |
| `/home/ciuser/app/cache/runtime-logs/` | Docker volume with timing logs |
| `/home/ciuser/app/log/test.log` | Rails test environment log |

---

## SSH Key Best Practices

### Prevent SSH Agent Key Cycling

When SSH Agent has many keys, SSH tries each one until MaxAuthTries (6) is reached. Use `IdentitiesOnly yes` to force specific key:

```bash
# Command line
ssh -o 'IdentitiesOnly yes' -i /path/to/key user@host

# In ~/.ssh/config
Host ci-runner-*
    IdentitiesOnly yes
    IdentityFile /tmp/ci_runner_key
    User root
```

**Sources:**
- [SSH Keys - ArchWiki](https://wiki.archlinux.org/title/SSH_keys)
- [Force SSH to use given private key - nixCraft](https://www.cyberciti.biz/faq/force-ssh-client-to-use-given-private-key-identity-file/)

---

## References

- Obsidian: [[DevOps/Bash-Heredoc-Variable-Interpolation]]
- Obsidian: [[DevOps/GitlabRegistryBuildWorkflow]]
- Obsidian: [[KnowledgeBase/Librarian/Logs_ReaderSkill/ephemeral_runner_access]]

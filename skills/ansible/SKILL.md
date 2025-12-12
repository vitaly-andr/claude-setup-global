---
name: ansible
description: Ansible automation for portal-main infrastructure deployment. Use when working with playbooks, roles, Jinja2 templates, Ansible Vault, or server configuration management.
---

# Ansible Infrastructure Automation (portal-main)

## Project Configuration

**ansible.cfg auto-loads vault password**:
```ini
vault_password_file = vault/.vault_pass
inventory = ansible/inventory.yml
roles_path = ./ansible/roles
```

**NEVER use `--ask-vault-pass`** - password file is configured in ansible.cfg!

## Portal-Main Structure

```
portal-main/
├── ansible.cfg                    # Main config (vault_password_file here!)
├── vault/.vault_pass              # Vault password (in .gitignore)
├── ansible/
│   ├── inventory.yml              # Host definitions
│   ├── group_vars/
│   │   ├── all.yml               # Global variables
│   │   ├── portal-main.yml       # Portal-specific vars
│   │   └── ceramir-portal/
│   │       └── vault.yml         # Encrypted secrets
│   ├── host_vars/
│   │   └── ceramir-portal-main.yml
│   ├── playbooks/
│   │   └── setup.yml             # Main playbook
│   └── roles/
│       ├── initial-setup/        # User, system, security, docker
│       ├── infrastructure/       # Network, mysql, redis, nginx
│       └── services/             # mailcow, seafile, onlyoffice, matrix
```

## Common Commands

### Playbook Execution
```bash
cd /home/vitaly/Projects/portal-main

# Syntax check
ansible-playbook --syntax-check ansible/playbooks/setup.yml

# Dry run (check mode)
ansible-playbook ansible/playbooks/setup.yml --check

# Full deployment
ansible-playbook ansible/playbooks/setup.yml

# Deploy specific service
ansible-playbook ansible/playbooks/setup.yml --tags matrix

# Deploy infrastructure only
ansible-playbook ansible/playbooks/setup.yml --tags infrastructure

# Deploy to specific host
ansible-playbook ansible/playbooks/setup.yml --limit ceramir-portal-main
```

### Ansible Vault
```bash
cd /home/vitaly/Projects/portal-main

# Create new vault file (password auto-loaded from ansible.cfg)
ansible-vault create ansible/group_vars/ceramir-portal/vault.yml

# Edit vault file
ansible-vault edit ansible/group_vars/ceramir-portal/vault.yml

# View vault file
ansible-vault view ansible/group_vars/ceramir-portal/vault.yml

# Encrypt existing file
ansible-vault encrypt file.yml

# Decrypt file (CAREFUL!)
ansible-vault decrypt file.yml
```

### Generate Strong Passwords
```bash
# Random 32-char password
openssl rand -base64 32

# Or with pwgen
pwgen -s 32 1
```

## Role Pattern (from portal-main)

### Task File Structure (7 Phases)
```yaml
---
# PHASE 1: INFRASTRUCTURE PREPARATION
- name: "📁 Create directory"
  ansible.builtin.file:
    path: "{{ var_install_path }}"
    state: directory
    mode: '0755'
  become: true
  tags: ['infrastructure', 'directories']

# PHASE 2: DATABASE PREPARATION
- name: "🗄️ Create PostgreSQL database"
  community.postgresql.postgresql_db:
    name: "{{ db_name }}"
    state: present
    login_host: "127.0.0.1"
    login_user: "postgres"
    login_password: "{{ vault_postgres_password }}"
  tags: ['database', 'postgresql']

# PHASE 3: CONFIGURATION DEPLOYMENT
- name: "🐳 Deploy Docker Compose"
  ansible.builtin.template:
    src: docker-compose.yml.j2
    dest: "{{ compose_path }}"
    backup: true
    mode: '0644'
  notify: restart service
  tags: ['configuration', 'docker']

# PHASE 4: SERVICE DEPLOYMENT
- name: "🚀 Start services"
  community.docker.docker_compose_v2:
    project_src: "{{ install_path }}"
    project_name: "{{ compose_project_name }}"
    state: present
    pull: "missing"
  tags: ['deployment', 'startup']

# PHASE 5: HEALTH CHECKS
- name: "⏱️ Wait for service"
  ansible.builtin.wait_for:
    port: "{{ service_port }}"
    host: "127.0.0.1"
    delay: 10
    timeout: 120
  tags: ['validation', 'health']

# PHASE 6: SSL CERTIFICATE
- name: "🔐 Obtain SSL certificate"
  ansible.builtin.command: >
    certbot certonly --webroot
    -w /var/www/html
    -d {{ hostname }}
    --email {{ letsencrypt_email }}
    --agree-tos
    --non-interactive
  when: not ssl_cert.stat.exists and not ansible_check_mode
  tags: ['ssl']

# PHASE 7: NGINX CONFIGURATION
- name: "🌐 Deploy Nginx config"
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: "/etc/nginx/sites-available/{{ hostname }}"
    backup: true
  notify: reload nginx
  tags: ['nginx']
```

### Handler Pattern
```yaml
handlers:
  - name: restart service
    community.docker.docker_compose_v2:
      project_src: "{{ install_path }}"
      project_name: "{{ compose_project_name }}"
      state: present
      recreate: always

  - name: reload nginx
    ansible.builtin.systemd:
      name: nginx
      state: reloaded

  - name: test nginx config
    ansible.builtin.command: nginx -t
    changed_when: false
```

### defaults/main.yml Pattern
```yaml
---
# Service toggle
service_enabled: true

# Version control
service_version: "latest"

# Paths
service_install_path: "/opt/service"
service_data_path: "/opt/service/data"

# Network
service_port: 8080
service_hostname: "service.example.com"

# Docker
service_container_name: "service"
service_compose_project_name: "service"
service_docker_network: "infrastructure-network"
```

## Variable Precedence (lowest to highest)

1. `roles/*/defaults/main.yml`
2. `group_vars/all.yml`
3. `group_vars/portal-main.yml`
4. `group_vars/ceramir-portal/vault.yml`
5. `host_vars/ceramir-portal-main.yml`
6. Extra vars (`-e`)

## Vault Variable Naming Convention

```yaml
# group_vars/ceramir-portal/vault.yml
vault_mysql_root_password: "..."
vault_postgres_password: "..."
vault_synapse_db_password: "..."
vault_matrix_registration_secret: "..."
vault_matrix_macaroon_secret: "..."
vault_matrix_form_secret: "..."
```

## Service Enable Pattern

```yaml
# group_vars/portal-main.yml
mailcow_enabled: true
seafile_enabled: false
onlyoffice_enabled: true
matrix_enabled: true  # Add for new services
```

## setup.yml Structure

```yaml
---
- name: Initial Setup (as root)
  hosts: portal-main
  remote_user: root
  gather_facts: true
  tags: [initial]
  roles:
    - role: initial-setup/user
      tags: [initial, user]
    - role: initial-setup/system
      tags: [initial, system]
    - role: initial-setup/security
      tags: [initial, security]
    - role: initial-setup/docker
      tags: [initial, docker]

- name: Infrastructure and Services (as deploy)
  hosts: portal-main
  remote_user: deploy
  become: true
  gather_facts: false
  tags: [infrastructure, services]

  handlers:
    - name: restart nginx
      ansible.builtin.systemd:
        name: nginx
        state: restarted
    # ... more handlers

  roles:
    # Infrastructure
    - role: infrastructure/network
      tags: [infrastructure, network]
    - role: infrastructure/mysql
      tags: [infrastructure, mysql]
    - role: infrastructure/redis
      tags: [infrastructure, redis]
    - role: infrastructure/nginx
      tags: [infrastructure, nginx]

    # Services (conditional)
    - role: services/matrix
      tags: [services, matrix]
      when: matrix_enabled | default(false)
```

## Jinja2 Template Patterns

### docker-compose.yml.j2
```yaml
version: "3.8"

services:
  {{ service_name }}:
    image: {{ service_image }}:{{ service_version }}
    container_name: {{ service_container_name }}
    restart: unless-stopped
    volumes:
      - {{ service_data_path }}:/data
    environment:
      - CONFIG_PATH=/data/config.yaml
    networks:
      - {{ service_docker_network }}
    ports:
      - "127.0.0.1:{{ service_port }}:8080"

networks:
  {{ service_docker_network }}:
    external: true
```

### nginx.conf.j2
```nginx
server {
    listen 443 ssl http2;
    server_name {{ service_hostname }};

    ssl_certificate /etc/letsencrypt/live/{{ service_hostname }}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/{{ service_hostname }}/privkey.pem;

    client_max_body_size {{ service_max_upload_size | default('50M') }};

    location / {
        proxy_pass http://127.0.0.1:{{ service_port }};
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $host;
    }
}

server {
    listen 80;
    server_name {{ service_hostname }};
    return 301 https://$server_name$request_uri;
}
```

## Debugging Commands

```bash
# Test connectivity
ansible portal-main -m ping

# Show all variables for a host
ansible portal-main -m debug -a "var=hostvars[inventory_hostname]"

# List tags
ansible-playbook ansible/playbooks/setup.yml --list-tags

# List tasks
ansible-playbook ansible/playbooks/setup.yml --list-tasks

# Verbose output
ansible-playbook ansible/playbooks/setup.yml -vvv
```

## CRITICAL: Password and Authentication Rules

**NEVER use these flags - ansible.cfg handles everything:**
- `--vault-password-file` - already in ansible.cfg
- `--ask-vault-pass` - already in ansible.cfg
- `-k` / `--ask-pass` - SSH keys configured
- `--become-pass` - passwordless sudo configured

**Correct usage (from portal-main directory):**
```bash
cd /home/vitaly/Projects/portal-main

# All commands work WITHOUT any password flags
ansible-playbook ansible/playbooks/setup.yml
ansible sputnik-portal -m shell -a "command"
ansible-vault edit ansible/group_vars/sputnik-portal/vault.yml
```

## References

- Ansible Docs: https://docs.ansible.com/
- Portal-Main Vault Guide: /home/vitaly/Projects/portal-main/ANSIBLE_VAULT_GUIDE.md
- Obsidian Note: /home/vitaly/Obsidian/SecondBrain/3 - Areas/DevOps/Ansible Inventory Structure Documentation.md
- Example Role: /home/vitaly/Projects/portal-main/ansible/roles/services/onlyoffice/

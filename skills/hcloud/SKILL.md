---
name: hcloud
description: Hetzner Cloud CLI for managing servers, networks, and cloud resources. Use when working with Hetzner Cloud infrastructure, CI runners, or server management.
---

# Hetzner Cloud CLI (hcloud)

## Version
Verified with: `hcloud version` = 1.57.0

## IMPORTANT: Authentication

**Claude cannot store tokens** - the HCLOUD_TOKEN must be retrieved from Bitwarden each session.

### Get Token from Bitwarden
```bash
# 1. Ask user to unlock Bitwarden
# User runs: bw unlock --raw
# User provides: BW_SESSION token

# 2. Sync and get token
BW_SESSION="<token>" bw sync
HCLOUD_TOKEN=$(BW_SESSION="<token>" bw get password "HetznerAPI-token")

# 3. Use with commands
HCLOUD_TOKEN="$HCLOUD_TOKEN" hcloud server list
```

### Alternative: Use Context (Persistent)
```bash
# Create a context (saves token to ~/.config/hcloud/cli.toml)
hcloud context create my-project

# List contexts
hcloud context list

# Switch context
hcloud context use my-project

# Show active context
hcloud context active
```

## Server Management

### List Servers
```bash
# List all servers
hcloud server list

# List with specific columns
hcloud server list -o columns=id,name,ipv4,status

# Filter by label
hcloud server list -l purpose=ci-runner

# Output as JSON
hcloud server list -o json
```

### Get Server Details
```bash
# Describe server by name or ID
hcloud server describe <name-or-id>

# Get server IP
hcloud server ip <name-or-id>

# Get as JSON
hcloud server describe <name-or-id> -o json
```

### Server Power Operations
```bash
# Power on
hcloud server poweron <name>

# Power off (immediate)
hcloud server poweroff <name>

# Shutdown (graceful)
hcloud server shutdown <name>

# Reboot
hcloud server reboot <name>

# Reset (hard reboot)
hcloud server reset <name>
```

### Create Server
```bash
hcloud server create \
  --type cx22 \
  --image ubuntu-24.04 \
  --location hel1 \
  --name my-server \
  --ssh-key my-key \
  --network my-network \
  --label "purpose=web"
```

### Delete Server
```bash
hcloud server delete <name-or-id>
```

### SSH to Server
```bash
# SSH directly via hcloud
hcloud server ssh <name>

# SSH with specific user
hcloud server ssh <name> -u root
```

## SSH Key Management

### List SSH Keys
```bash
hcloud ssh-key list
```

### Create SSH Key
```bash
hcloud ssh-key create --name my-key --public-key "ssh-ed25519 AAAA..."

# Or from file
hcloud ssh-key create --name my-key --public-key-from-file ~/.ssh/id_ed25519.pub
```

### Delete SSH Key
```bash
hcloud ssh-key delete <name-or-id>
```

## Network Management

### List Networks
```bash
hcloud network list
```

### Get Network Details
```bash
hcloud network describe <name>
```

## Finding CI Runners

CI runners are created dynamically by GitLab CI. To find them:

```bash
# List servers with CI runner label
hcloud server list -l purpose=ci-runner

# Find by name pattern (ci-runner-*)
hcloud server list | grep ci-runner

# Get specific runner IP
hcloud server ip ci-runner-my-openproject
```

### Current Infrastructure
- **Sputnik-Portal** (37.27.29.22) - Main server with GitLab
- **ci-runner-*** - Ephemeral CI runners (created/destroyed per pipeline)

## Common Patterns

### Get Running CI Runner IP
```bash
# Find currently running CI runner
RUNNER_IP=$(hcloud server list -o json | jq -r '.[] | select(.name | startswith("ci-runner")) | .public_net.ipv4.ip')
echo "CI Runner IP: $RUNNER_IP"
```

### SSH to CI Runner
```bash
# Get CI SSH key from Bitwarden first
CI_KEY=$(BW_SESSION="<token>" bw get notes "CI_SSH_PRIVATE_KEY")
echo "$CI_KEY" > /tmp/ci_key && chmod 600 /tmp/ci_key

# SSH to runner
RUNNER_IP=$(hcloud server ip ci-runner-my-openproject)
ssh -i /tmp/ci_key root@$RUNNER_IP
```

### Check Server Status
```bash
# Quick status check
hcloud server list -o columns=name,status,ipv4
```

## Output Formats

```bash
# Table (default)
hcloud server list

# JSON
hcloud server list -o json

# YAML
hcloud server list -o yaml

# Specific columns
hcloud server list -o columns=id,name,ipv4,status

# No header
hcloud server list -o noheader
```

## References

- Hetzner Cloud CLI: https://github.com/hetznercloud/cli
- Hetzner Cloud API: https://docs.hetzner.cloud/

---

**Last Verified**: 2025-12-09
**hcloud Version**: 1.57.0

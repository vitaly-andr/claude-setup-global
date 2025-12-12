---
name: bitwarden
description: Bitwarden CLI and SSH Agent integration for secrets management and SSH authentication. Use when working with bw commands, vault unlock/lock, SSH key authentication via Bitwarden, or secrets retrieval.
---

# Bitwarden CLI and SSH Agent

## Version
Verified with: `bw --version` = 2025.11.0

## Architecture Overview

**Important**: Bitwarden has TWO separate components with independent unlock states:

1. **Bitwarden Desktop App** - GUI application with SSH Agent
2. **Bitwarden CLI (`bw`)** - Command-line tool requiring BW_SESSION

These are **NOT synchronized** - unlocking one does not unlock the other.

## CLI Status Check

```bash
# Check vault status (returns JSON)
bw status
```

Output:
```json
{
  "serverUrl": "https://bitwarden.example.com",
  "lastSync": "2020-06-16T06:33:51.419Z",
  "userEmail": "user@example.com",
  "userId": "00000000-0000-0000-0000-000000000000",
  "status": "unlocked"
}
```

Status values: `unlocked`, `locked`, `unauthenticated`

## Unlock/Lock Vault

### Interactive Unlock
```bash
# Prompts for master password
bw unlock
```

### Non-Interactive Unlock
```bash
# From environment variable
bw unlock --passwordenv BW_PASSWORD

# From file (first line is password)
bw unlock --passwordfile ~/path/to/password.txt

# Get only session key (for scripts)
bw unlock --raw
```

### After Unlocking - CRITICAL
```bash
# Must export session key for CLI to work
export BW_SESSION="<session-key-from-unlock>"

# Or pass with each command
bw list items --session "<session-key>"
```

### Lock Vault
```bash
bw lock
```

## Login/Logout

```bash
# Interactive login
bw login

# With API key
bw login --apikey

# SSO login
bw login --sso

# Check login status
bw login --check

# Logout
bw logout
```

## Sync Vault

```bash
# Pull latest vault data
bw sync

# Force full sync
bw sync -f

# Get last sync timestamp
bw sync --last
```

## IMPORTANT: Claude Cannot Run Interactive Commands

**Claude cannot run `bw unlock` interactively** - it requires user input for the master password.

When you need to use Bitwarden CLI:
1. **Ask the user** to run `bw unlock --raw` in their terminal
2. User provides the BW_SESSION token
3. Use the session with: `BW_SESSION="<token>" bw <command>`

Example workflow:
```
Claude: "Please run `bw unlock --raw` and provide the session token"
User: [runs command, provides token]
Claude: BW_SESSION="<token>" bw sync  # Always sync first!
Claude: BW_SESSION="<token>" bw list items --search "keyword"
```

**IMPORTANT: Always run `bw sync` after getting BW_SESSION** to ensure you have the latest items from the cloud.

## Search and Retrieve Items

### List Items
```bash
# List all items (requires BW_SESSION)
bw list items

# Search items by keyword
bw list items --search "hetzner"

# Filter by folder
bw list items --folderid <folder-id>

# Output as JSON for parsing
bw list items --search "api" | jq '.[].name'
```

### Get Specific Item
```bash
# Get item by ID
bw get item <item-id>

# Get item by search term (returns first match)
bw get item "Hetzner API"

# Get just the password
bw get password "Hetzner API"

# Get username
bw get username "gitlab.com"

# Get TOTP code
bw get totp "github.com"

# Get notes
bw get notes "SSH Key"
```

### Get Item Fields
```bash
# Get full item as JSON and extract custom field
bw get item "Hetzner API" | jq -r '.fields[] | select(.name=="token") | .value'

# Get login password directly
bw get item "Hetzner API" | jq -r '.login.password'
```

## Create Items

### Create Item from Template
```bash
# Get template for login item
bw get template item

# Create item (base64-encoded JSON)
echo '{"type":1,"name":"My Item","login":{"username":"user","password":"pass"}}' | base64 | bw create item
```

### Create Secure Note
```bash
# Type 2 = Secure Note
echo '{"type":2,"name":"My Note","notes":"Secret content here"}' | base64 | bw create item
```

### Create Folder
```bash
echo '{"name":"My Folder"}' | base64 | bw create folder
```

## SSH Agent Integration

### Socket Location (Linux native)
```bash
~/.bitwarden-ssh-agent.sock
```

### Environment Variable
```bash
export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
```

### Check SSH Agent Keys
```bash
# List all keys in agent
ssh-add -l

# Bitwarden keys typically named 'bitwarden-ssh'
ssh-add -l | grep bitwarden
```

### SSH Agent Behavior
- **Desktop Unlocked**: SSH operations work, may prompt for confirmation
- **Desktop Locked**: SSH prompts to unlock Bitwarden Desktop
- **Keys in Agent**: Available even when CLI shows "locked"

## Common Workflows

### Full CLI Unlock Workflow
```bash
# 1. Unlock vault
bw unlock

# 2. Export session (copy from unlock output)
export BW_SESSION="<session-key>"

# 3. Verify
bw status | jq .status  # Should show "unlocked"
```

### Script-Safe Unlock
```bash
# Set password in environment first
export BW_PASSWORD="your-master-password"

# Unlock and capture session
BW_SESSION=$(bw unlock --passwordenv BW_PASSWORD --raw)
export BW_SESSION

# Now CLI commands work
bw list items
```

### Check SSH Readiness
```bash
# Check if SSH keys are available
ssh-add -l

# Test SSH connection
ssh -T git@github.com
```

## Troubleshooting

### "status": "locked" after `bw unlock`
**Cause**: BW_SESSION not exported
```bash
# Fix: Export the session key
export BW_SESSION="<key-from-unlock-output>"
```

### SSH not using Bitwarden keys
**Cause**: SSH_AUTH_SOCK not set correctly
```bash
# Fix: Set socket path
export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
```

### "Vault is locked" but Desktop is open
**Cause**: Desktop and CLI have separate unlock states
```bash
# Fix: Unlock CLI separately
bw unlock
export BW_SESSION="<key>"
```

## Best Practices

1. **Add to shell profile** for persistent session:
   ```bash
   # ~/.bashrc or ~/.zshrc
   export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
   ```

2. **Never store BW_SESSION permanently** - it's a security risk

3. **Use `--raw` for scripts** to get just the session key

4. **Check status before operations**:
   ```bash
   bw status | jq -r '.status'
   ```

## References

- Bitwarden CLI: https://bitwarden.com/help/cli/
- SSH Agent: https://bitwarden.com/help/ssh-agent/
- API Key Auth: https://bitwarden.com/help/personal-api-key/

---

**Last Verified**: 2025-12-08
**Bitwarden CLI Version**: 2025.11.0

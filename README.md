# Claude Code Global Configuration

This repository contains global configuration and knowledge base for Claude Code.

## Structure

```
.claude/
├── agents/              # Global agents (sysadmin, librarian)
│   ├── sysadmin.md     # System administration expert
│   └── librarian.md    # Fact-checker and knowledge validator
├── knowledge/           # Memory bank and knowledge base
│   ├── sysadmin/       # System administration knowledge
│   │   ├── arch-linux/
│   │   ├── hyprland/
│   │   ├── waybar/
│   │   ├── common-issues/
│   │   └── solutions/
│   ├── METHODOLOGY.md  # Knowledge management methodology
│   ├── QUICK-START.md  # Quick start guide
│   └── README.md       # Knowledge base overview
└── settings.json       # Global Claude Code settings
```

## What's Included

### Global Agents
- **sysadmin**: Expert on Arch Linux, Hyprland, Waybar system configuration
- **librarian**: Fact-checker and knowledge base validator

### Knowledge Base
- Arch Linux package management and configuration
- Hyprland window manager setup
- Waybar status bar configuration
- Common issues and solutions
- Tested solutions archive

### Settings
- Permission rules for safe operation
- Editor configuration
- Session cleanup settings

## What's NOT Included (gitignored)

These are session-specific and should NOT be shared:
- `todos/` - Session todo lists
- `debug/` - Debug information
- `shell-snapshots/` - Shell state snapshots
- `projects/` - Project-specific settings
- `file-history/` - File edit history
- `statsig/` - Statistics and analytics
- `session-env/` - Session environment data
- `history.jsonl` - Command history
- `.credentials.json` - API credentials (NEVER commit!)

## Usage

### Initial Setup
```bash
cd ~/.claude
git clone git@github.com:vitaly-andr/claude-setup-global.git .
```

### Updating Configuration
```bash
cd ~/.claude
git pull
```

### Saving Changes
```bash
cd ~/.claude
git add agents/ knowledge/ settings.json
git commit -m "Update: description"
git push
```

## Project-Specific Agents

This repository contains GLOBAL configuration only. Each project should have its own `.claude/` directory with project-specific agents and settings. Global agents will be available across all projects.

## Contributing

When adding new solutions to the knowledge base:
1. Solve the problem successfully
2. Call librarian agent to validate the solution
3. Save to `knowledge/sysadmin/solutions/` with date prefix
4. Update category files if appropriate
5. Commit and push

See `knowledge/METHODOLOGY.md` for details.

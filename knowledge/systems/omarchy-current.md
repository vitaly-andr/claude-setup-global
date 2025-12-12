# Omarchy System State

**Last Updated**: 2025-01-19
**System**: EliteMini (Arch Linux 6.17.8-arch1-1)

## Core Configuration

**Shell**: zsh
- Config: `~/.zshrc` (Oh My Zsh, robbyrussell theme, mise integration)
- Plugins: git

**Desktop Environment**: Hyprland 0.52.1
- Config: `~/.config/hypr/hyprland.conf`
- Terminal: kitty (future: alacritty + tmux)
- Launcher: wofi
- File Manager: dolphin

**Status Bar**: Waybar 0.14.0
- Config: `~/.config/waybar/config`
- Style: `~/.config/waybar/style.css`

**Terminal**: Kitty
- Config: `~/.config/kitty/kitty.conf`
- Font: JetBrains Mono 11
- Note: User prefers Alacritty + tmux (future migration planned)

**Notifications**: Mako
- Config: `~/.config/mako/config`

**Screenshots**: Swappy
- Config: `~/.config/swappy/config`

## Development Tools

**Git**: 2.48.1
- Identity: Vitaly Andrianov <vitaly.andr@gmail.com>
- Location: /usr/bin/git

**Docker**: Running
- Aliases: dps, dpsa, di (in .zshrc when migrated from .bashrc)

**Claude Code**: Installed
- Global config: `~/.claude/`

**Obsidian**: Synced
- Vault: `~/Obsidian/Work_with_claude/`

## Dotfiles Management

**Status**: ✅ FULLY CONFIGURED
**Method**: Bare repository
**Location**: `~/.omarchy-dotfiles/`
**Alias**: `omc` (shortened from omcfg)
**Branch**: main
**Initial Commit**: f3a7a73
**Remote**: Not configured yet (planned)

**Files Tracked** (9 total):
- Shell: `.zshrc`, `.bashrc`
- Git: `.gitconfig` (with aliases: st, co, br, lg, etc.)
- Hyprland: `.config/hypr/hyprland.conf`
- Waybar: `.config/waybar/config.jsonc`, `.config/waybar/style.css`
- Kitty: `.config/kitty/kitty.conf`
- Docs: `README.md`
- Ignore: `.gitignore` (enhanced with cloud/VPN/container patterns)

**Important Rule**: When installing new tools, ALWAYS remind user to update `~/.gitignore`

**Usage**: `omc st`, `omc add <file>`, `omc cm -m "msg"`, `omc push` (when remote configured)

## Configurations to Track

- `~/.zshrc` (current shell)
- `~/.bashrc` (legacy, keep for compatibility)
- `~/.config/hypr/hyprland.conf`
- `~/.config/waybar/config`
- `~/.config/waybar/style.css`
- `~/.config/kitty/kitty.conf` (temporary, until Alacritty migration)
- `~/.config/mako/config`
- `~/.config/swappy/config`
- `~/.gitconfig` (to be created with aliases)

## NOT Installed Yet

- Bitwarden Desktop (documented, pending installation)
- Alacritty (preferred terminal, not installed)
- tmux configuration (preferred multiplexer, not configured)

## File System

**Home**: `/home/vitaly`
**Storage**: NVMe encrypted btrfs
**No external backup disks** (different from testing environment)

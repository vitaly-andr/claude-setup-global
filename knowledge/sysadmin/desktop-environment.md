# Desktop Environment Configuration

## Hyprland Configuration

### Screenshot Management

#### Directory Configuration
See: [Hyprland Screenshot Directory](solutions/2025-10-22-hyprland-screenshot-directory.md)

Configure custom screenshot output directory for Omarchy/Hyprland using `OMARCHY_SCREENSHOT_DIR` environment variable in `~/.config/hypr/envs.conf`.

**Quick Reference**:
```bash
env = OMARCHY_SCREENSHOT_DIR,/home/vitaly/Pictures/Screenshots
```

## Omarchy Configuration System

Omarchy is a Hyprland configuration framework that provides:
- Pre-configured keybindings
- Theme management
- Utility scripts (screenshot, screen recording, etc.)

**Configuration locations**:
- User configs: `~/.config/hypr/`
- Omarchy defaults: `~/.local/share/omarchy/default/hypr/`
- Omarchy scripts: `~/.local/share/omarchy/bin/`

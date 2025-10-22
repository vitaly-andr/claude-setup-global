# Screenshot Directory Configuration - Hyprland/Omarchy

**Date**: 2025-10-22
**Status**: Validated
**Environment**: Hyprland (Wayland) + Omarchy + grim + satty
**OS**: Arch Linux

## Problem
Screenshots were being saved to `/home/vitaly/Pictures/` instead of `/home/vitaly/Pictures/Screenshots/`

## Root Cause
The `omarchy-cmd-screenshot` script uses the environment variable `OMARCHY_SCREENSHOT_DIR` to determine the output directory. If not set, it defaults to `XDG_PICTURES_DIR` or `$HOME/Pictures`.

**Script logic** (`~/.local/share/omarchy/bin/omarchy-cmd-screenshot:4`):
```bash
OUTPUT_DIR="${OMARCHY_SCREENSHOT_DIR:-${XDG_PICTURES_DIR:-$HOME/Pictures}}"
```

## Solution
Set the `OMARCHY_SCREENSHOT_DIR` environment variable in Hyprland configuration.

**File to modify**: `~/.config/hypr/envs.conf`

**Add this line**:
```bash
env = OMARCHY_SCREENSHOT_DIR,/home/vitaly/Pictures/Screenshots
```

**Important**: Replace `/home/vitaly` with `$HOME` or actual username path.

## How It Works

1. User presses `PRINT` key
2. Hyprland executes `omarchy-cmd-screenshot` (defined in `~/.local/share/omarchy/default/hypr/bindings/utilities.conf:33`)
3. Script reads `OMARCHY_SCREENSHOT_DIR` environment variable
4. Screenshot is captured with `grim` and edited with `satty`
5. Output is saved to `$OMARCHY_SCREENSHOT_DIR/screenshot-YYYY-MM-DD_HH-MM-SS.png`

## Prerequisites

1. **Install required packages**:
   ```bash
   sudo pacman -S grim satty slurp wl-clipboard
   ```

2. **Create screenshots directory**:
   ```bash
   mkdir -p ~/Pictures/Screenshots
   ```

3. **Reload Hyprland configuration**:
   ```bash
   hyprctl reload
   # OR restart Hyprland session
   ```

## Verification

```bash
# Take a screenshot with PRINT key
# Check output directory
ls -lh ~/Pictures/Screenshots/

# Should see: screenshot-YYYY-MM-DD_HH-MM-SS.png
```

## Technical Details

- **Screenshot tool**: `grim` (v1.4+, Wayland screenshot utility)
- **Screenshot editor**: `satty` (annotation tool)
- **Desktop environment**: Hyprland (Wayland compositor)
- **Configuration framework**: Omarchy
- **Key binding**: Defined in `~/.local/share/omarchy/default/hypr/bindings/utilities.conf`

## Related Configurations

**Additional screenshot options**:
- `PRINT` - Full screen screenshot with editor
- `SHIFT+PRINT` - Screenshot to clipboard
- `ALT+PRINT` - Screen recording menu

## Troubleshooting

**If screenshots still go to wrong directory**:
1. Verify environment variable is set:
   ```bash
   env | grep OMARCHY_SCREENSHOT_DIR
   ```

2. Check script is using correct variable:
   ```bash
   cat ~/.local/share/omarchy/bin/omarchy-cmd-screenshot | grep OUTPUT_DIR
   ```

3. Ensure Hyprland reloaded configuration:
   ```bash
   hyprctl reload
   ```

**If directory doesn't exist**:
```bash
mkdir -p ~/Pictures/Screenshots
```

## Sources
- grim documentation: https://sr.ht/~emersion/grim/
- Hyprland environment variables: https://wiki.hyprland.org/Configuring/Environment-variables/
- Tested: 2025-10-22 on Arch Linux (kernel 6.17.3)

## Tags
`#hyprland` `#omarchy` `#screenshot` `#wayland` `#grim` `#arch-linux` `#desktop-environment`

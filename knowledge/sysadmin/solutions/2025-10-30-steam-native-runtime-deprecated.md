# Steam Native Runtime - Deprecated Package

**Status**: VALIDATED
**Date**: 2025-10-30
**Scope**: Global (All Arch Linux systems)
**Category**: System Administration / Package Management

## Problem

Understanding why `steam-native-runtime` is no longer recommended on Arch Linux and what to use instead.

## Solution

**Do NOT use `steam-native-runtime`**. Use the standard `steam` package with Valve's bundled runtime instead.

## Key Facts

### 1. What is steam-native-runtime
- Package that replaces Steam's bundled runtime libraries with system-native versions
- Previously available in `multilib` repository
- Aimed to reduce disk space and use system libraries instead of Valve's bundled ones

### 2. Why Deprecated
- **Removed from official repos**: As of 2025, no longer in Arch Linux official repositories
- **GTK2 dependency**: Requires deprecated GTK2 which Arch Linux is phasing out
- **Legacy libraries**: Depends on outdated versions (glew1.10, libpng12, etc.)
- **Security concerns**: Legacy libraries don't receive CVE fixes
- **Maintenance burden**: Keeping old library versions is unsustainable

### 3. Current Status
- **Official repos**: Removed from `multilib`
- **AUR availability**: Exists in AUR but **NOT RECOMMENDED**
- **Arch recommendation**: Use default Steam with bundled runtime
- **Valve recommendation**: Use bundled runtime for best compatibility

### 4. Best Practice
✅ **Use**: `steam` (default package with bundled runtime)
❌ **Avoid**: `steam-native-runtime` (deprecated, AUR only)

### 5. Why Bundled Runtime is Better
- Officially supported and tested by Valve
- Self-contained (no dependency conflicts)
- More stable across different Linux distributions
- Regular security updates from Valve
- Better game compatibility
- Works consistently on all distros

## Installation

```bash
# Install Steam (recommended)
sudo pacman -S steam

# Check installation
pacman -Q steam

# Launch Steam
steam
```

## Verification Commands

```bash
# Check Steam package is installed
pacman -Q steam

# Verify bundled runtime location
ls ~/.local/share/Steam/ubuntu12_32/steam-runtime/

# Check runtime version
cat ~/.local/share/Steam/ubuntu12_32/steam-runtime/version.txt

# Launch Steam (uses bundled runtime automatically)
steam
```

## What NOT to Do

❌ **DO NOT use**: `steam-native-runtime` or `STEAM_RUNTIME=0`
- Causes library version conflicts
- Mesa drivers may fail to load
- Games crash or won't start
- Officially deprecated by Valve and Arch

## Sources
- Arch Linux Packages: https://archlinux.org/packages/multilib/x86_64/steam/
- AUR Package (deprecated): https://aur.archlinux.org/packages/steam-native-runtime
- Package verification: `pacman -Si steam`
- System status: Verified on Arch Linux (current as of 2025-10-30)
- pacman logs: `/var/log/pacman.log`

## Related Information

### Proton for Windows Games
Steam includes Proton (Wine-based compatibility layer) for running Windows games on Linux. Works best with the bundled runtime.

### 32-bit Library Requirements
Steam requires 32-bit libraries from the `multilib` repository. Ensure multilib is enabled in `/etc/pacman.conf`.

### First Launch
On first run, Steam will:
1. Download updates
2. Set up runtime environment
3. Create `~/.local/share/Steam/` directory
4. Download Proton if needed for Windows games

## Tags
`#arch-linux` `#steam` `#gaming` `#package-management` `#deprecated` `#runtime` `#multilib`

# Arch Linux Package Executable Name Verification

**Skill**: arch-package-check
**Purpose**: Verify actual executable names for Arch Linux packages

## Problem

Package names often differ from executable names in Arch Linux:
- Package `bitwarden` → executable `bitwarden-desktop`
- Package `visual-studio-code-bin` → executable `code`
- Package `signal-desktop` → executable `signal-desktop`

## Verification Protocol

### Step 1: Check installed files
```bash
pacman -Ql <package-name> | grep -E "(bin/|\.desktop)"
```

**Purpose**: Shows ALL files installed by the package, including binaries

**Example**:
```bash
$ pacman -Ql bitwarden | grep -E "(bin/|\.desktop)"
bitwarden /usr/bin/
bitwarden /usr/bin/bitwarden-desktop
bitwarden /usr/share/applications/bitwarden.desktop
```

### Step 2: Check desktop file (for GUI apps)
```bash
grep "Exec=" /usr/share/applications/<package-name>.desktop
```

**Purpose**: Desktop file contains the ACTUAL command used to launch the app

**Example**:
```bash
$ grep "Exec=" /usr/share/applications/bitwarden.desktop
Exec=bitwarden-desktop %U
```

**IMPORTANT**: Use SYSTEM path `/usr/share/applications/`, NOT user path `~/.local/share/applications/`

### Step 3: Verify executable exists
```bash
which <executable-name>
```

**Purpose**: Confirms the executable is in PATH and shows its location

**Example**:
```bash
$ which bitwarden-desktop
/usr/bin/bitwarden-desktop
```

### Step 4: Additional verification (optional)
```bash
ls -la /usr/bin/<executable>*
```

**Purpose**: Shows all related executables and symlinks

## Common Mistakes

| Package Name | ❌ Assumed Executable | ✅ Actual Executable |
|--------------|----------------------|---------------------|
| bitwarden | bitwarden | bitwarden-desktop |
| visual-studio-code-bin | vscode | code |
| signal-desktop | signal | signal-desktop |
| google-chrome | chrome | google-chrome-stable |

## Usage in Workflow

### For Planner/Reviewer agents:
When a plan involves launching an Arch package, use this skill:

```markdown
Invoking arch-package-check skill for package: bitwarden

✅ Step 1: pacman -Ql bitwarden | grep bin
Result: /usr/bin/bitwarden-desktop

✅ Step 2: grep "Exec=" /usr/share/applications/bitwarden.desktop
Result: Exec=bitwarden-desktop %U

✅ Step 3: which bitwarden-desktop
Result: /usr/bin/bitwarden-desktop

**Confirmed executable name**: bitwarden-desktop
```

### For DevOps agent:
This protocol should be automatically applied when configuring Arch packages.

## Critical Rules

1. ❌ **NEVER assume** package name = executable name
2. ✅ **ALWAYS verify** using `pacman -Ql` first
3. ✅ **Check SYSTEM paths** (`/usr/share/applications/`) not user paths
4. ✅ **Include evidence** in your analysis (show command outputs)

## Template for Verification Report

```markdown
## Arch Package Verification: <package-name>

**Step 1: Check installed files**
```bash
$ pacman -Ql <package> | grep -E "(bin/|\.desktop)"
<output>
```

**Step 2: Check desktop file**
```bash
$ grep "Exec=" /usr/share/applications/<package>.desktop
<output>
```

**Step 3: Verify executable**
```bash
$ which <executable>
<output>
```

**Conclusion**: Package `<package>` installs executable `<executable>`
```

## When to Use This Skill

- ✅ When planning keybinding changes
- ✅ When creating application launchers
- ✅ When writing systemd services for GUI apps
- ✅ When troubleshooting "command not found" errors
- ✅ When updating configuration files that reference executables

## Integration with DevOps Agent

The DevOps agent should automatically apply this verification protocol for:
- Hyprland bindings configuration
- Application launcher scripts
- Systemd service files
- Desktop environment configurations

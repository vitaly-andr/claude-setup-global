# Claude Code Skills

This directory contains skills - reusable knowledge packages that agents automatically activate based on context.

## What are Skills?

**Skills** are passive knowledge packages in Markdown format that automatically activate based on the agent's work context. Unlike agents, which are active entities called explicitly, skills are automatically loaded when relevant keywords or contexts are detected.

## Available Skills

### System Administration

#### arch-linux
- **Description**: Arch Linux package management (pacman, yay/paru)
- **Triggers**: pacman, AUR, Arch Linux, package management
- **Use cases**: Installing packages, system updates, troubleshooting

#### systemd-timers
- **Description**: Systemd user timers for task scheduling (recommended over cron)
- **Triggers**: scheduling, cron, timer, automated tasks
- **Use cases**: Periodic tasks, automated maintenance, scheduled scripts

### Desktop Environment

#### hyprland
- **Description**: Hyprland wayland compositor configuration
- **Triggers**: Hyprland, window manager, wayland, compositor
- **Use cases**: WM configuration, keybinds, monitor setup, animations

#### waybar
- **Description**: Waybar status bar configuration
- **Triggers**: waybar, status bar, bar configuration
- **Use cases**: Status bar modules, styling, troubleshooting display

### Documentation

#### obsidian-vault
- **Description**: Obsidian vault structure and documentation format
- **Triggers**: documentation, obsidian, notes, knowledge base
- **Use cases**: Creating technical documentation, organizing knowledge

## Skill Structure

Each skill is a directory containing a `SKILL.md` file:

```
skill-name/
└── SKILL.md
```

### SKILL.md Format

```markdown
---
name: skill-name
description: Clear description of what this skill does and when to use it
---

# Skill Content

[Instructions, examples, and guidelines that agents will follow]
```

## How Skills Work

### Automatic Activation

Skills are automatically embedded into agent context when:
- Specific keywords are mentioned in the task
- Work context matches the skill description
- Agent needs specific information

Example:
```
User: Install Docker on Arch Linux
         ↓
Main Agent → activates arch-linux skill
          → executes task with skill knowledge
```

### Skills with Subagents

**Important**: Subagents CAN use skills!

```
Main Agent → calls devops subagent
                ↓
        devops → auto-activates arch-linux skill
               → auto-activates systemd-timers skill
               → uses both skills during execution
```

All agents (main and subagents) have access to the same shared set of skills.

## Benefits of Skills

### DRY Principle

Instead of duplicating instructions in each agent:

❌ **Without skills:**
```
devops agent: Contains Arch Linux commands, systemd commands
obsidian-agent: Duplicates Arch Linux commands
```

✅ **With skills:**
```
devops agent: Uses arch-linux skill, systemd-timers skill
obsidian-agent: Uses arch-linux skill, obsidian-vault skill

Skills (shared):
- arch-linux.md
- systemd-timers.md
- obsidian-vault.md
```

### Composition

Agents can use multiple skills simultaneously:

```
devops agent
    ├── arch-linux skill
    ├── systemd-timers skill
    ├── hyprland skill
    └── waybar skill
```

## Creating New Skills

### Template

```bash
mkdir ~/.claude/skills/my-skill
nano ~/.claude/skills/my-skill/SKILL.md
```

```markdown
---
name: my-skill
description: Description of what this skill does and when to use it
---

# My Skill

## Quick Reference

[Common commands and patterns]

## Examples

[Practical examples]

## Best Practices

[Guidelines for using this skill]

## References

[Sources and documentation links]
```

### Best Practices

✅ **Create skills for:**
- Repeating commands and procedures
- Standards and project conventions
- Checklists and best practices
- Reference information

❌ **Don't create skills for:**
- One-time instructions
- Project-specific code
- Information that frequently changes

### Naming Conventions

```
arch-linux/SKILL.md          ✅ Good (descriptive)
docker-best-practices/SKILL.md ✅ Good (clear purpose)
my-skill/SKILL.md            ❌ Bad (unclear)
s1/SKILL.md                  ❌ Bad (unintelligible)
```

### Size Guidelines

- **Small, focused skills are better than large ones**
- One skill = one knowledge area
- Easier to combine multiple small skills

```
✅ Good:
- arch-linux/
- systemd-timers/
- hyprland/

❌ Bad:
- everything-about-linux/
```

## Integration with Agents

Skills are automatically available to all agents. When updating agent instructions, reference skills rather than duplicating their content.

**Example Agent:**
```markdown
---
name: devops
description: Expert on Arch Linux, Hyprland, and system configuration
tools: Read, Edit, Bash, Grep, Glob
---

You are an expert on system administration and configuration.

Skills are automatically activated based on context:
- arch-linux: Package management
- systemd-timers: Task scheduling
- hyprland: Window manager configuration
- waybar: Status bar configuration
```

## Verification

### Check Skills Installation

```bash
# List all skills
ls -la ~/.claude/skills/

# Read a specific skill
cat ~/.claude/skills/arch-linux/SKILL.md
```

### Testing

Ask an agent to perform a task that should activate a skill and verify that instructions from the skill are being applied.

## Troubleshooting

### Skill Not Activating

1. Check file location:
   ```bash
   ls ~/.claude/skills/your-skill/SKILL.md
   ```

2. Verify YAML frontmatter format
3. Ensure description is clear and relevant
4. Make skill name more specific

### Conflicts Between Skills

If two skills give contradictory instructions:
- Make skills more specific
- Use project-specific skills to override
- Split into narrower areas

## Related Documentation

- [Claude Code Skills System](~/Obsidian/Work_with_claude/Development/Tools/2025-10-21-claude-code-skills-system.md)
- [Anthropic Skills Repository](https://github.com/anthropics/skills)
- [Skills Specification](https://github.com/anthropics/skills/blob/main/agent_skills_spec.md)

---

**Last Updated**: 2025-10-22
**Location**: `~/.claude/skills/`

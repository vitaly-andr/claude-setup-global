---
name: obsidian-vault
description: Obsidian vault structure and documentation format for technical notes, solutions, and knowledge base. Use when creating or organizing documentation in Obsidian vault at ~/Obsidian/Work_with_claude/.
---

# Obsidian Vault Structure

Location: `~/Obsidian/Work_with_claude/`

## Note Format

All notes should include YAML frontmatter with the following structure:

```yaml
---
type: solution | knowledge | troubleshooting | tool | configuration
category: system | development | devops | database
tags: [tag1, tag2, tag3]
date: YYYY-MM-DD
status: solved | documented | needs-review | in-progress
difficulty: easy | medium | hard
related: [other-note-name]
---
```

### Frontmatter Fields Explained

- **type**: Nature of the document
  - `solution`: Problem-solving documentation
  - `knowledge`: General knowledge and reference
  - `troubleshooting`: Diagnostic guides
  - `tool`: Tool-specific documentation
  - `configuration`: Configuration guides

- **category**: Main domain
  - `system`: System administration (Arch, Hyprland, Waybar)
  - `development`: Software development
  - `devops`: Deployment, containers, CI/CD
  - `database`: Database solutions

- **tags**: Specific keywords for searchability
- **date**: Creation/last update date
- **status**: Current state of documentation
- **difficulty**: Complexity level
- **related**: Links to related notes (without `.md` extension)

## Folder Structure

```
~/Obsidian/Work_with_claude/
├── System/              # System administration
│   ├── Arch/           # Arch Linux specific
│   ├── Hyprland/       # Hyprland WM
│   └── Waybar/         # Waybar status bar
├── Development/         # Software development
│   ├── Tools/          # Development tools
│   └── Languages/      # Programming languages
├── DevOps/             # Deployment and operations
│   ├── Docker/         # Containerization
│   └── CI-CD/          # Continuous integration
├── Database/           # Database solutions
└── Troubleshooting/    # Problem-solving notes
```

## Document Structure Template

```markdown
---
type: [type]
category: [category]
tags: [tag1, tag2, tag3]
date: YYYY-MM-DD
status: [status]
difficulty: [difficulty]
related: []
---

# [Title]

## Context

[Describe the situation, problem, or use case]

## Solution / Knowledge

[Main content: step-by-step solution or knowledge documentation]

### Example

[Provide practical examples if applicable]

## Explanation

[Why this solution works, underlying principles]

## Alternatives

[Other possible approaches, if any]

## Troubleshooting

[Common issues and their solutions]

## References

- [Source 1]
- [Source 2]

---

**Created**: YYYY-MM-DD
**Agent**: [agent-name if created by agent]
**Files referenced**: [list of relevant files]
```

## Naming Conventions

### File Names

- Use descriptive, hyphenated lowercase names
- Include date prefix for solutions: `YYYY-MM-DD-description.md`
- Examples:
  - `2025-10-22-systemd-timers-over-cron.md`
  - `arch-linux-package-management.md`
  - `hyprland-keybindings-guide.md`

### Folder Organization

- Keep folder depth to 2-3 levels maximum
- Use clear, categorical folder names
- Group by domain first, then by specificity

## Best Practices

1. **Always include frontmatter**: Every note needs proper metadata
2. **Use clear titles**: Make them searchable and descriptive
3. **Add examples**: Practical examples are essential
4. **Reference sources**: Always cite where information came from
5. **Link related notes**: Use `related` field to connect knowledge
6. **Update dates**: Change date field when significantly updating
7. **Use tags wisely**: 3-5 relevant tags per note

## Content Guidelines

### For Solution Notes
- Include full context of the problem
- Provide step-by-step instructions
- Explain why the solution works
- Add troubleshooting section

### For Knowledge Notes
- Organize by topic sections
- Include quick reference commands
- Add common use cases
- Provide practical examples

### For Troubleshooting Notes
- Describe symptoms clearly
- List diagnostic steps
- Provide multiple solutions if available
- Include prevention tips

## Integration with Agents

When agents create documentation:
1. Use this format consistently
2. Fill all frontmatter fields
3. Follow folder structure
4. Link to existing related notes
5. Include agent name in footer

## References

- Obsidian Documentation: https://help.obsidian.md/
- Markdown Guide: https://www.markdownguide.org/

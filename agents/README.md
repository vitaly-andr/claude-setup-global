# Claude Code Agents

This directory contains specialized agents for the Claude Code workflow system.

## Directory Structure

```
agents/
├── workflow/              # Main workflow pipeline
│   ├── planner.md        # Analyzes requests, creates plans
│   ├── reviewer.md       # Validates plans with fact-checking
│   ├── worker.md         # Implements approved plans
│   ├── tester.md         # Creates and runs tests
│   ├── security.md       # Security audits
│   └── deployer.md       # Git operations (commit, push, PR, tags)
│
├── documentation/         # Knowledge and documentation
│   ├── knowledge-keeper.md    # Validates solutions, creates ADRs, manages knowledge base
│   └── technical-writer.md    # Creates user documentation, reports, release notes
│
├── domain/                # Domain experts
│   └── devops.md         # Arch Linux, Hyprland, system configuration
│
└── tools/                 # Utility agents
    ├── git-helper.md     # Git information and help
    └── obsidian-agent.md # Obsidian vault management
```

## Workflow Pipeline

The standard workflow follows this sequence:

1. **planner** → Analyzes user request, creates detailed plan
2. **reviewer** → Validates plan, performs fact-checking
3. **worker** → Implements approved plan
4. **tester** → Creates and runs tests
5. **security** → Performs security audit
6. **deployer** → Creates commits, pushes, creates PR

## Documentation Agents

### knowledge-keeper
- Validates solutions before saving to knowledge base
- Creates Architecture Decision Records (ADR)
- Maintains project memory and session logs
- Manages `.claude/knowledge/` (both global and project)

### technical-writer
- Creates user-facing documentation
- Generates implementation reports
- Writes release notes
- Manages `docs/` and `.claude/archives/`
- Calls obsidian-agent for Obsidian vault summaries

## Division of Responsibilities

### Documentation vs Knowledge

| Type | knowledge-keeper | technical-writer |
|------|------------------|------------------|
| ADRs | ✅ Creates & maintains | ❌ |
| Session logs | ✅ Creates | ❌ |
| Validated solutions | ✅ Saves to `.claude/knowledge/` | ❌ |
| User documentation | ❌ | ✅ Creates in `docs/` |
| Implementation reports | ❌ | ✅ Creates in `.claude/archives/` |
| Release notes | ❌ | ✅ Creates |
| API documentation | ❌ | ✅ Creates in `docs/` |

### Git Operations vs Information

| Type | deployer | git-helper |
|------|----------|------------|
| Create commits | ✅ | ❌ |
| Push to remote | ✅ | ❌ |
| Create PR/MR | ✅ | ❌ |
| Create tags | ✅ | ❌ |
| Show history | ❌ | ✅ |
| Explain commands | ❌ | ✅ |
| Help with conflicts | ❌ | ✅ |
| Repository health check | ❌ | ✅ |

**deployer**: Performs git write operations
**git-helper**: Provides git information and help

## Agent Models

- **planner**: `claude-opus-4-thinking` (needs deep reasoning)
- **security**: `claude-opus-4-thinking` (critical analysis)
- **knowledge-keeper**: `opus` (validation requires thorough analysis)
- **Others**: `inherit` (use session default)

## Key Features

### planner
- **MUST** read actual files before planning
- **FORBIDDEN**: Predict timelines unless explicitly requested
- **MUST** provide evidence in plans

### reviewer
- **MANDATORY** fact-checking of all claims
- **MANDATORY** version verification
- **MUST** independently verify key claims
- Uses Context7 MCP + WebSearch for validation

### worker
- **MUST** document errors in detail
- **MUST** study logs before conclusions
- **FORBIDDEN**: Simplify plan without approval
- **MUST** follow plan exactly

### knowledge-keeper
- Validates solutions before saving
- Creates ADRs for significant decisions
- Maintains project memory
- Context-aware (global vs project)

### technical-writer
- Creates comprehensive user documentation
- Generates implementation reports and release notes
- Calls obsidian-agent for vault summaries
- Division: detailed docs in project, brief summaries in Obsidian

### deployer
- **REQUIRES** user approval before commits
- Follows Conventional Commits format
- Creates PR using `gh` CLI
- Manages release tags

### git-helper
- Read-only git operations
- Explains commands and best practices
- Helps understand repository state
- Guides through conflict resolution

### obsidian-agent
- Full-featured agent (not just sync tool)
- Creates condensed summary notes
- Links back to detailed project docs
- **Future**: Candidate for MCP server integration

## Usage Examples

### Full Workflow
```bash
# User provides task
/workflow "Add authentication to API"

# Workflow executes:
# planner → reviewer → worker → tester → security → deployer
```

### Create ADR
```bash
# Call knowledge-keeper directly
"Create an ADR for our decision to use PostgreSQL instead of MySQL"
```

### Document Implementation
```bash
# Call technical-writer
"Create implementation report for the authentication feature we just built"
```

### Git Help
```bash
# Call git-helper
"Explain the difference between git merge and git rebase"
```

## Future Evolution

### devops Agent
- **Status**: First candidate for restructuring
- **Potential split**:
  - `linux-expert.md` - Linux system management
  - `desktop-environment-expert.md` - Hyprland, Waybar
  - `infrastructure-expert.md` - Docker, deployment

### obsidian-agent
- **Current**: Full agent for creating Obsidian notes
- **Future**: MCP server integration
  - Direct search queries
  - Faster knowledge retrieval
  - Real-time vault access

## See Also

- [Workflow Guide](../.claude/WORKFLOW_GUIDE.md)
- [Knowledge Methodology](../knowledge/METHODOLOGY.md)
- [Agent Memory Bank](../.claude/knowledge/)

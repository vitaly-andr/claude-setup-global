---
description: Save a new solution to the Knowledge Base (Obsidian + Weaviate)
---

# Save Solution

Use `mcp__feedback_server__save_solution` to save to Knowledge Base.

## Parameters

| Field | Required | Description |
|-------|----------|-------------|
| **title** | Yes | Solution title (min 5 chars) |
| **problem** | Yes | Problem description (min 10 chars) |
| **solution_text** | Yes | Solution content (min 20 chars) |
| **verification** | Yes | How to verify it works (min 10 chars) |
| **when_works** | Yes | List of scenarios where it works |
| **when_fails** | Yes | List of caveats/failures (NEVER empty!) |
| **applicable_agents** | Yes | Agents this applies to |
| **tags** | Yes | Searchable tags (min 2) |
| **author** | Yes | Creator |
| **workflow_id** | No | Workflow ID that created this (e.g., `wf_xxx`) |
| **workflow_description** | No | Brief description of the task being done |

## Workflow Traceability

When saving a solution from a workflow, **always include**:
- `workflow_id`: The workflow ID (e.g., `wf_abc123`)
- `workflow_description`: Brief summary of what you asked me to do

This allows tracing solutions back to the original task context.

## User Input

```text
$ARGUMENTS
```

{{#if $ARGUMENTS}}
Parse the arguments and call `mcp__feedback_server__save_solution`.
{{else}}
Ask: "Describe the solution you want to save. Include:
- What problem does it solve?
- What's the solution?
- What workflow/task created this? (if applicable)"
{{/if}}

## Saves To

- Obsidian: `~/Obsidian/AgentKnowledgeBase/Solutions/{STATUS}/{filename}.md`
- Weaviate: Vector indexed for semantic search

## Frontmatter Fields Saved

```yaml
solution_id: sol_xxx
title: "..."
status: PROPOSED
created_date: 2025-12-11
workflow_id: wf_xxx          # Traceability
workflow_description: "..."  # What task was being done
# ... other fields
```

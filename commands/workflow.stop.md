---
description: Stop a running workflow
---

# Stop Workflow

Use `mcp__workflow_server__workflow_stop` to halt a workflow.

## Parameters

- **workflow_id** (required): Workflow ID to stop
- **reason** (optional): Reason for stopping

## User Input

```text
$ARGUMENTS
```

{{#if $ARGUMENTS}}
Call `mcp__workflow_server__workflow_stop` with workflow_id and reason.
{{else}}
Check `.workflow/state.yaml` for current workflow_id, or ask user.
{{/if}}

## Behavior

- Saves current state
- Marks workflow as paused
- Can be resumed later with `/workflow.resume`

---
description: Resume a paused or interrupted workflow
---

# Resume Workflow

Use `mcp__workflow_server__workflow_resume` to continue a workflow.

## Parameters

- **workflow_id** (required): Workflow ID to resume

## User Input

```text
$ARGUMENTS
```

{{#if $ARGUMENTS}}
Call `mcp__workflow_server__workflow_resume` with workflow_id.
{{else}}
Check `.workflow/state.yaml` for current workflow_id, or ask user.
{{/if}}

## Behavior

- Resumes from last checkpoint
- Continues with next pending phase
- Requires user approval at each gate

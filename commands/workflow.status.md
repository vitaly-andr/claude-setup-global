---
description: Get status of a running or completed workflow
---

# Workflow Status

Use `mcp__workflow_server__get_workflow_status` to check workflow state.

## Parameters

- **workflow_id** (required): Workflow ID (e.g., `wf_xxx-xxx`)

## User Input

```text
$ARGUMENTS
```

{{#if $ARGUMENTS}}
Call `mcp__workflow_server__get_workflow_status` with workflow_id from arguments.
{{else}}
Check `.workflow/state.yaml` for current workflow_id, or ask user.
{{/if}}

## Returns

- Current phase and status
- Completed phases
- Pending phases
- History of events

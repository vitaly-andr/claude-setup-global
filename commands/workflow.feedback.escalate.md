---
description: Escalate a solution failure to determine retry or user escalation
---

# Escalate Failure

Use `mcp__feedback_server__escalate_failure` to handle failures.

## Parameters

- **solution_id** (required): Solution that failed
- **agent_name** (required): Agent that failed
- **failure_reason** (required): Why it failed
- **retry_count** (optional): Current retry attempt (default: 0)

## User Input

```text
$ARGUMENTS
```

{{#if $ARGUMENTS}}
Parse the arguments and call `mcp__feedback_server__escalate_failure` with provided values.
{{else}}
Ask: "Please provide: solution_id, agent_name, and failure_reason"
{{/if}}

## Returns

- `escalate: false` → Retry with `next_agent`
- `escalate: true` → Show escalation message to user

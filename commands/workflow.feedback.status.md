---
description: Manually update a solution's status (PROPOSED, VERIFIED, PROVEN, DEPRECATED, NEEDS_REVIEW)
---

# Update Solution Status

Use `mcp__feedback_server__update_solution_status` to manually change a solution's status.

## Status Lifecycle

```
PROPOSED → VERIFIED → PROVEN
    ↓          ↓
NEEDS_REVIEW ← ┘
    ↓
DEPRECATED
```

## Automatic Promotion (via submit_feedback)

- **PROPOSED → VERIFIED**: 3+ successful uses
- **VERIFIED → PROVEN**: 10+ successful uses with 80%+ success rate
- **Any → NEEDS_REVIEW**: 5+ uses with <50% success rate

## Manual Override

This command allows manual status changes when:
- You've manually verified a solution works
- A solution should be deprecated
- A solution needs immediate review

## Parameters

- **solution_id** (required): Solution ID (e.g., `sol_xxx-xxx`)
- **new_status** (required): PROPOSED, VERIFIED, PROVEN, DEPRECATED, or NEEDS_REVIEW
- **reason** (optional): Reason for the status change

## User Input

```text
$ARGUMENTS
```

{{#if $ARGUMENTS}}
Parse the arguments and call `mcp__feedback_server__update_solution_status` with provided values.
{{else}}
First, list solutions using `mcp__search_server__list_solutions` to help user select one.
Then ask: "Please provide: solution_id and new_status (PROPOSED, VERIFIED, PROVEN, DEPRECATED, NEEDS_REVIEW)"
{{/if}}

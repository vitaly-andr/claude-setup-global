---
description: Run curation on solutions to update status based on feedback
---

# Curate Solutions

Use `mcp__curation_server__curate_solutions` to update solution statuses.

## What It Does

- Updates solution status based on success/failure rates
- PROPOSED → VERIFIED (after first success)
- VERIFIED → PROVEN (3+ successes, 100% rate)
- Any → NEEDS_REVIEW (>30% failure rate)

## Parameters

- **dry_run** (optional): Preview changes without applying (default: false)

## User Input

```text
$ARGUMENTS
```

{{#if $ARGUMENTS}}
If "dry-run" in arguments, set dry_run=true.
{{/if}}

Call `mcp__curation_server__curate_solutions`.

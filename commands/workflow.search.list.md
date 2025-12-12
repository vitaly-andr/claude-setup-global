---
description: List all solutions in the Knowledge Base with optional filters
---

# List Solutions

Use `mcp__search_server__list_solutions` to browse all solutions.

## Parameters

- **status** (optional): Filter by status (PROPOSED, VERIFIED, PROVEN, DEPRECATED)
- **category** (optional): Filter by category
- **limit** (optional): Max results (default: 20)

## User Input

```text
$ARGUMENTS
```

{{#if $ARGUMENTS}}
Parse filters from arguments and call `mcp__search_server__list_solutions`.
{{else}}
Call `mcp__search_server__list_solutions` with no filters to show all.
{{/if}}

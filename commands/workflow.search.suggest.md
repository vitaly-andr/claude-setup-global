---
description: Get solution suggestions based on a problem description
---

# Suggest Solutions

Use `mcp__search_server__suggest_solutions` to find relevant solutions.

## Parameters

- **query** (required): Problem description or search query
- **limit** (optional): Max results (default: 5)
- **min_confidence** (optional): Minimum confidence score (0.0-1.0)

## User Input

```text
$ARGUMENTS
```

{{#if $ARGUMENTS}}
Call `mcp__search_server__suggest_solutions` with the query from arguments.
{{else}}
Ask: "What problem are you trying to solve? I'll search for relevant solutions."
{{/if}}

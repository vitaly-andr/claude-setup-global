---
description: Perform semantic search across all solutions in Knowledge Base
---

# Semantic Search

Use `mcp__search_server__semantic_search` for vector-based search.

## Parameters

- **query** (required): Natural language search query
- **top_k** (optional): Number of results (default: 10)
- **min_confidence** (optional): Minimum confidence score
- **min_success_rate** (optional): Filter by success rate

## User Input

```text
$ARGUMENTS
```

{{#if $ARGUMENTS}}
Call `mcp__search_server__semantic_search` with the query.
{{else}}
Ask: "What would you like to search for?"
{{/if}}

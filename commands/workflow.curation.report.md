---
description: Generate monthly quality report for the Knowledge Base
---

# Generate Monthly Report

Use `mcp__curation_server__generate_monthly_report` to create quality report.

## What It Generates

- Solution count by status
- Top performing solutions
- Solutions needing attention
- Usage statistics
- Trend analysis

## Parameters

- **month** (optional): Month in YYYY-MM format (default: current month)

## User Input

```text
$ARGUMENTS
```

{{#if $ARGUMENTS}}
Parse month from arguments if provided.
{{/if}}

Call `mcp__curation_server__generate_monthly_report`.

Report saved to: `~/Obsidian/AgentKnowledgeBase/Feedback-Reports/{YYYY-MM}-monthly-report.md`

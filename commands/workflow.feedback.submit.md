---
description: Submit feedback for a solution execution (success or failure)
---

# Submit Feedback

Records execution results for a solution used during a workflow.

## When to Use

- **After workflow phase completion**: Record success/failure of solution execution
- **Automatic status promotion**: Triggers PROPOSED → VERIFIED → PROVEN based on success rate

For **manual status updates** (without workflow context), use `/workflow.feedback.status` instead.

## Step 1: List Available Solutions

First, call `mcp__search_server__list_solutions` to show available solutions with:
- Solution ID
- Title
- Current status
- Success rate
- Times used

## Step 2: Gather Required Information

After showing solutions, ask user for:

| Field | Required | Description |
|-------|----------|-------------|
| **solution_id** | Yes | Select from list (e.g., `sol_xxx-xxx`) |
| **workflow_id** | Yes | Workflow ID with brief description of what was being done |
| **agent_name** | Yes | Agent that executed: worker, planner, tester, reviewer, security, deployer, technical-writer |
| **exit_code** | Yes | 0 = success, non-zero = failure |
| **agent_output** | No | Output or error message |
| **execution_time_ms** | No | Execution time in milliseconds |

## Status Promotion Rules

- **PROPOSED → VERIFIED**: After 3+ successful uses
- **VERIFIED → PROVEN**: After 10+ successful uses with 80%+ success rate
- **Any → NEEDS_REVIEW**: If success rate drops below 50% after 5+ uses

## User Input

```text
$ARGUMENTS
```

{{#if $ARGUMENTS}}
Parse the arguments and call `mcp__feedback_server__submit_feedback` with provided values.
{{else}}
1. First call `mcp__search_server__list_solutions` to display available solutions
2. Then ask: "Which solution do you want to submit feedback for? Please provide:
   - **Solution** (number or ID from list)
   - **Workflow description** (brief summary of what you asked me to do)
   - **Agent** (worker, planner, tester, etc.)
   - **Result** (success or failure)"
{{/if}}

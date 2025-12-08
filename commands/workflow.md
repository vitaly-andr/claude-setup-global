---
description: Run agent workflow via MCP orchestrator (calls HTTP agent servers on ports 11001-11008)
---

# MCP Orchestrator Workflow

**IMPORTANT**: This command calls the MCP orchestrator which sends HTTP requests to agent servers.
Do NOT use Task tool subagents - use the MCP tools below.

## Step 1: Get the Task

{{#if $ARGUMENTS}}
**User Request**: $ARGUMENTS

Proceed to Step 2.
{{else}}
Ask the user: "What task would you like the workflow to handle?"

Wait for user response before proceeding.
{{/if}}

## Step 2: Get Working Directory

Run `pwd` using Bash tool to get the current working directory.

Confirm with user: "I'll run this workflow in: [path]. Is this correct?"

## Step 3: Call MCP Orchestrator

**MANDATORY**: Use this exact MCP tool call (do NOT use Task tool):

```
mcp__agent_orchestrator__orchestrator_workflow_run
```

Parameters:
- `task`: The user's task description
- `working_dir`: The confirmed working directory path
- `pipeline`: ["planner", "reviewer", "worker", "tester", "security", "deployer"]
- `format`: "markdown"

## Step 4: Show Progress

After the workflow starts, display agent transitions:

```
═══════════════════════════════════════════════════════════
AGENT: [agent_name]
═══════════════════════════════════════════════════════════
Status: [RUNNING/COMPLETED/FAILED]
Summary: [what agent did]
Next: [next_agent or "WORKFLOW COMPLETE"]
═══════════════════════════════════════════════════════════
```

Use `mcp__agent_orchestrator__orchestrator_workflow_status` to poll for updates.

## Step 5: Handle Results

- **If APPROVED**: Continue to next agent
- **If NEEDS_REVISION**: Stop and inform user
- **If FAILED**: Stop and show error

## Pipeline

```
Planner → Reviewer → Worker → Tester → Security → Deployer
   ↓          ↓         ↓         ↓          ↓          ↓
 Plan     Validate  Implement   Test     Audit     Commit
```

All agents run as HTTP servers on localhost:11001-11008.

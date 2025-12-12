---
description: Complete AI agent workflow with user approval gates at every critical decision point
---

# AI Agent Workflow

**Purpose**: Run multi-agent workflows with **strict phase-by-phase execution** and **user approval gates**. Each phase ends with a testable deliverable that you verify by prompting the agent.

## Core Principle

> **"The phase is my test by prompting the agent and I absolutely don't care how many steps you need to achieve this goal"**

- Each PHASE must end with something YOU can test by PROMPTING the agent
- Claude does ALL necessary work to reach that testable state (unlimited steps)
- User manually tests by prompting the agent
- User approves or requests fixes
- Only then proceed to next phase

## User Input

```text
$ARGUMENTS
```

{{#if $ARGUMENTS}}
**Task Description**: $ARGUMENTS
{{else}}
Ask the user: "What task would you like the workflow to handle?"

Wait for user response before proceeding.
{{/if}}

---

## PHASE 0: Initialize & Plan

### Steps (Claude executes all):

1. **Generate Workflow ID**: `wf_{uuid}`
2. **Create State Directory**: `mkdir -p .workflow`
3. **Analyze the task** and break it into PHASES where each phase results in:
   - Something the USER can TEST by PROMPTING an MCP tool or agent
   - A clear verification prompt the user can run
4. **Create state file** `.workflow/state.yaml`:

```yaml
workflow_id: wf_{uuid}
status: planning
task: "{task description}"
created_at: "{ISO timestamp}"
phases:
  - id: 1
    name: "{Phase Name}"
    status: pending
    test_prompt: "{Exact prompt user runs to test}"
    mcp_tools: ["{tool1}", "{tool2}"]
  - id: 2
    name: "{Phase Name}"
    status: pending
    test_prompt: "{Exact prompt user runs to test}"
    mcp_tools: ["{tool1}"]
current_phase: 0
```

5. **Present plan to user**:

```
═══════════════════════════════════════════════════════════
WORKFLOW PLAN: {workflow_id}
═══════════════════════════════════════════════════════════
Task: {description}

PHASES:
┌─────┬────────────────────────┬─────────────────────────────┐
│ #   │ Phase                  │ Your Test                   │
├─────┼────────────────────────┼─────────────────────────────┤
│ 1   │ {Phase 1 Name}         │ Prompt: {test_prompt}       │
│ 2   │ {Phase 2 Name}         │ Prompt: {test_prompt}       │
│ ... │ ...                    │ ...                         │
└─────┴────────────────────────┴─────────────────────────────┘

Ready to begin Phase 1?
═══════════════════════════════════════════════════════════
```

### User Approval Gate:
**STOP** and wait for user to approve the plan or request changes.

---

## PHASE N: Execute Phase (Repeat for each phase)

### Steps (Claude executes ALL necessary work):

1. **Update state**: Set `current_phase: N`, phase status: `in_progress`
2. **Do ALL implementation work** needed for this phase:
   - Write code, fix bugs, add tests
   - Configure MCP servers
   - Run automated tests
   - Fix any issues found
3. **Verify with automated tests** before presenting to user
4. **Update state**: Record what was done
5. **Present testable result**:

```
═══════════════════════════════════════════════════════════
PHASE {N} COMPLETE: {Phase Name}
═══════════════════════════════════════════════════════════
What was done:
- {bullet points of work completed}

Automated tests: ✓ PASSED / ✗ FAILED

YOUR TEST:
  {Exact prompt to run}

Example:
  > {example_prompt}

Expected result:
  {what user should see}

Type "approved" to continue to Phase {N+1}
Type "fix: {issue}" to request changes
═══════════════════════════════════════════════════════════
```

### User Approval Gate:
**STOP** and wait for user to:
- Test by prompting the agent/tool
- Reply "approved" to continue
- Reply "fix: {issue}" to fix problems

If user requests fix:
1. Fix the issue
2. Re-run automated tests
3. Present again for approval

### Solution Status Check (After User Approval):
After user approves, **ALWAYS** ask:

```
═══════════════════════════════════════════════════════════
SOLUTION STATUS UPDATE
═══════════════════════════════════════════════════════════
Did this phase use or create a reusable solution?

If YES, would you like to:
1. Save new solution → /workflow.feedback.save
2. Update existing solution status → /workflow.feedback.status
3. Submit execution feedback → /workflow.feedback.submit

If NO, type "continue" to proceed to Phase {N+1}
═══════════════════════════════════════════════════════════
```

This ensures the Knowledge Base stays updated with successful patterns.

---

## PHASE FINAL: Completion

### Steps:

1. **Update state**: `status: completed`

2. **Archive workflow to Obsidian** (ALWAYS do this):

Save all workflow artifacts to `~/Obsidian/AgentKnowledgeBase/Workflows/{workflow_id}/`:
- `index.md` - Workflow summary with task description and status
- `plan.md` - All phases with their status and work done
- `diary.md` - Complete execution history
- `solutions.md` - Links to all solutions created

Use the ObsidianSyncService's `save_workflow()` method with:
- workflow_id: The workflow ID
- task_description: Original task
- status: "completed" or "failed"
- phases: All phases from state.yaml
- history: All history events from state.yaml
- solutions_created: List of solution IDs created

3. **Save solution to Knowledge Base** (if successful):

Use `mcp__feedback_server__save_solution` with:
- title: Summary of what was built
- problem: Original task description
- solution_text: Key implementation details
- verification: How to verify it works
- when_works: Conditions for success
- when_fails: Known limitations
- applicable_agents: Which agents can use this
- tags: Relevant tags
- author: "workflow"
- **workflow_id**: The workflow ID (for traceability!)
- **workflow_description**: Brief task description

This creates a **backlink** from the solution to the workflow.

4. **Final report**:

```
═══════════════════════════════════════════════════════════
WORKFLOW COMPLETE ✓
═══════════════════════════════════════════════════════════
ID: {workflow_id}
Task: {description}
Phases: {N} completed

Archived to Obsidian:
  ~/Obsidian/AgentKnowledgeBase/Workflows/{workflow_id}/

Solutions saved to Knowledge Base:
- {solution_id}: {title}
  (backlink: [[Workflows/{workflow_id}/index]])

State: .workflow/state.yaml
═══════════════════════════════════════════════════════════
```

---

## MCP Tools Available

### Feedback Server (`feedback_server`)
- `submit_feedback` - Record execution results
- `escalate_failure` - Handle failures
- `save_solution` - Save to Knowledge Base

### Agent Orchestrator (`agent_orchestrator`)
- `orchestrator_workflow_run` - Run full pipeline
- `orchestrator_workflow_status` - Check status
- `orchestrator_agent_call` - Call single agent

### Obsidian (`obsidian`)
- `obsidian_write_note` - Write to vault
- `obsidian_read_note` - Read from vault

---

## State File Reference

`.workflow/state.yaml`:

```yaml
workflow_id: wf_{uuid}
status: planning|active|paused|completed|failed
task: "{description}"
created_at: "{ISO}"
last_updated: "{ISO}"
current_phase: 0
phases:
  - id: 1
    name: "{name}"
    status: pending|in_progress|completed|failed
    test_prompt: "{prompt}"
    mcp_tools: []
    started_at: null
    completed_at: null
    user_approved: false
    work_done: []
history:
  - timestamp: "{ISO}"
    event: phase_started|phase_completed|user_approved|fix_requested
    phase: 1
    details: "{}"
```

---

## Error Handling

If a phase fails:

1. Update state with failure details
2. Present error to user with:
   - What failed
   - Error details
   - Suggested fix
3. Wait for user guidance:
   - "retry" - Try again
   - "skip" - Skip this phase (if safe)
   - "abort" - Stop workflow

---

## Key Rules

1. **NEVER mark a phase complete without user approval**
2. **ALWAYS test before presenting to user** - run automated tests first
3. **ALWAYS provide exact test prompt** - user should know exactly what to type
4. **NEVER proceed to next phase without "approved"**
5. **FIX issues until user approves** - no moving on with broken phases
6. **SAVE to Knowledge Base** - successful workflows become reusable solutions

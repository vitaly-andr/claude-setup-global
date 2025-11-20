---
description: Complete AI agent workflow with user approval gates at every critical decision point
---

# AI Agent Workflow

**User Request**: $ARGUMENTS

---

## Workflow Overview

This workflow executes specialized agents with **MANDATORY USER APPROVAL** at every critical decision point.

### Core Workflow Pipeline

```
┌──────────┐     ┌──────────┐     ┌────────┐     ┌────────┐     ┌──────────┐     ┌──────────┐
│ Planner  │ --> │ Reviewer │ --> │ Worker │ --> │ Tester │ --> │ Security │ --> │ Deployer │
│ (Task)   │     │ (Task)   │     │ (Task) │     │ (Task) │     │ (Task)   │     │ (Task)   │
└──────────┘     └──────────┘     └────────┘     └────────┘     └──────────┘     └──────────┘
     ↓                ↓               ↓               ↓                ↓               ↓
  USER           USER            USER            USER             USER            USER
  APPROVAL       APPROVAL        APPROVAL        APPROVAL         APPROVAL        APPROVAL
```

### Supporting Agents (Called as Needed)

These agents support the workflow but are not part of the main pipeline:

- **knowledge-keeper** - Validate solutions, create ADRs, manage knowledge base
- **technical-writer** - Create documentation, reports, release notes
- **git-helper** - Git information and help (read-only)
- **obsidian-agent** - Manage Obsidian vault notes
- **devops** - System administration and DevOps tasks

**When to Use Supporting Agents:**

- **knowledge-keeper**: After solving complex problems - validate solution before saving to knowledge base, create ADR for significant decisions
- **technical-writer**: After implementation - create user-facing documentation, implementation reports, release notes
- **git-helper**: When you need git information - history, conflicts help, command explanations (read-only)
- **obsidian-agent**: After technical-writer creates docs - create condensed Obsidian summary with link to detailed docs
- **devops**: For system configuration, Arch Linux, Hyprland, infrastructure tasks

---

## Phase 0: Task Classification (router)

**BEFORE starting the main workflow, classify the task and identify relevant agents/skills.**

**🔍 Router should read diary for context**

Router should check diary at `~/Obsidian/Work_with_claude/01-Diary/` to understand:
- Recent work history
- Technologies being used
- What's already been done

Use the router subagent to:

1. **Check diary** for context (read recent 2-3 entries)
2. Read descriptions of all available agents
3. Read descriptions of all available skills
4. Match the user's request to agent/skill descriptions
5. Return recommendations

**Request**: $ARGUMENTS

Router will return:
- **Recommended Agents**: Which agents match this task
- **Recommended Skills**: Which skills are relevant
- **Notes**: Brief observations (include diary context if relevant)

**How to use router recommendations:**

- If router recommends **devops** → Consider using devops directly (Task tool) for simple system tasks, or continue with workflow for complex multi-step tasks
- If router recommends **planner/worker** → Continue with standard workflow
- If router recommends other specialized agents → Planner should delegate to those agents

**Router does NOT decide complexity or routing - it just matches task to descriptions.**

**After router completes**: Review recommendations and proceed to Phase 1 (Planning).

---

## Phase 1: Planning (planner)

Use the planner subagent to analyze the request:

**Request**: $ARGUMENTS

**🔍 MANDATORY FIRST STEP: Read the Diary**

Before creating any plan, planner **MUST** read the project diary to understand:
- What has already been done
- What documentation exists
- What problems were solved
- What remains to be done

**Diary Location**: `~/Obsidian/Work_with_claude/01-Diary/`

**Planner must**:
1. List all diary entries: `ls -lt ~/Obsidian/Work_with_claude/01-Diary/ | head -10`
2. Read the most recent 3-5 relevant entries
3. Identify what has been completed
4. Identify what documentation exists
5. Understand the current state
6. Plan ONLY the remaining work (don't duplicate what's done!)

**Example**: If diary shows "documentation created", don't plan to create documentation again. Plan the actual implementation instead.

Create comprehensive plan with:
- Executive Summary
- Diary Analysis (what's already done based on diary)
- Technical Analysis (with evidence from actual files)
- Step-by-step implementation plan (ONLY remaining work)
- Acceptance criteria
- Questions for user

**⚠️ PLANNER RULES**:
- **MANDATORY**: Read diary FIRST before planning
- **MANDATORY**: Check what's already done in diary
- **MANDATORY**: Don't duplicate completed work
- You may ONLY read files and search codebase
- You may NOT modify or create any files
- **MUST** read actual files before making claims
- **FORBIDDEN**: Predict timelines unless user explicitly requests
- If you need clarification, ASK THE USER
- End with: STATUS: AWAITING_USER_APPROVAL

---

**🛑 MANDATORY USER APPROVAL CHECKPOINT**

After Planner completes, **USER MUST**:
1. Review the entire plan
2. Answer any questions from Planner
3. Request modifications if needed
4. Explicitly approve: "I approve the plan, proceed to Reviewer"

**DO NOT PROCEED TO REVIEWER WITHOUT EXPLICIT USER APPROVAL!**

---

## Phase 2: Plan Validation (reviewer)

**Only after user approves the plan:**

Use the reviewer subagent to validate the approved plan using:

1. Context7 MCP - Get latest official documentation
2. WebSearch - Find recent updates, CVEs, security advisories
3. Read existing code - Check project patterns
4. **MANDATORY FACT-CHECKING** - Verify ALL technical claims
5. **VERSION VERIFICATION** - Check all library versions are current

Validate ALL technologies mentioned in the plan.

**⚠️ REVIEWER RULES**:
- **MANDATORY**: Fact-check every technical assertion
- **MANDATORY**: Verify current library versions
- **MUST**: Independently verify key claims (don't trust planner blindly)
- You may ONLY read and search (no file modifications!)
- If documentation is unclear, ASK THE USER
- Provide specific recommendations with examples
- End with: STATUS: APPROVED / NEEDS_REVISION / REJECTED

---

**🛑 MANDATORY USER APPROVAL CHECKPOINT**

After Reviewer completes, **USER MUST**:
1. Review validation report and fact-checking results
2. Understand all issues found
3. Decide:
   - "Approved, proceed to Worker" (if STATUS: APPROVED)
   - "Send back to Planner with Reviewer feedback" (if NEEDS_REVISION)
   - "Restart planning" (if REJECTED)

**DO NOT PROCEED TO IMPLEMENTATION WITHOUT EXPLICIT USER APPROVAL!**

---

## Phase 3: Implementation (worker)

**Only after user approves Reviewer validation:**

Use the worker subagent to implement the approved plan.

**📋 Implementation Process**:

Follow the approved plan step-by-step. For EACH implementation step:

### Step-by-Step Implementation Rules

1. **BEFORE modifying or creating ANY file**:
   - Announce: "📝 I need to modify/create [filename]"
   - Explain: "Changes needed: [description]"
   - Show the proposed changes (use code blocks)
   - **WAIT FOR USER APPROVAL**: "May I proceed with this change?"

2. **AFTER user approves each change**:
   - Use Write/Edit tool to make the change
   - Use Read tool to verify the change
   - Report: "✅ Change completed successfully"
   - Show verification output

3. **If you encounter ANY problem**:
   - **STOP immediately**
   - **MANDATORY**: Document error in detail
   - **MANDATORY**: Study logs and error messages thoroughly
   - Explain the problem clearly with evidence from logs
   - Propose 2-3 solutions with pros/cons
   - **WAIT for user decision**

4. **If you need to deviate from the plan**:
   - **FORBIDDEN**: Simplify plan without approval
   - STOP and explain why deviation is necessary
   - Propose alternative approach
   - Explain impact on original plan
   - **WAIT for user approval**

5. **For running commands on server/system**:
   - Show the command first: `command here`
   - Explain what it will do and expected output
   - **WAIT for user approval**
   - Execute with Bash tool
   - Report results

**⚠️ WORKER RULES**:
- **MANDATORY**: Document errors in detail
- **MANDATORY**: Study logs before making conclusions
- **FORBIDDEN**: Simplify or skip plan steps without explicit approval
- **FORBIDDEN**: Proceed with partial implementation if errors occur
- Follow plan exactly unless user approves deviation
- Use TodoWrite to track progress

---

**🛑 MULTIPLE USER APPROVAL CHECKPOINTS**

During Implementation:

- ✋ Approve/reject EACH file modification
- ✋ Approve/reject EACH file creation
- ✋ Approve/reject EACH command execution
- ✋ Answer any clarification questions
- ✋ Request changes or rollback if needed
- ✋ Approve deviations from plan

After ALL changes complete, **USER MUST**:

- Review all changes made
- Verify all acceptance criteria are addressed
- Check that all files are correct
- Explicitly approve: "Implementation approved, proceed to Testing"

**DO NOT PROCEED TO TESTER WITHOUT EXPLICIT USER APPROVAL!**

---

## Phase 4: Testing (tester)

**Only after user approves all implementations:**

Use the tester subagent to:

**Phase 4a: Analysis (Read-only)**
1. Analyze project test infrastructure
2. Read existing tests
3. Identify technology stack
4. Propose testing strategy
5. **WAIT FOR USER APPROVAL OF STRATEGY**

**⚠️ TESTER RULES**:

1. **After analysis, BEFORE creating/running any tests**:
   - Present testing strategy to user
   - Show which tests you plan to create
   - Explain testing approach
   - **WAIT FOR USER APPROVAL**: "May I proceed with this testing approach?"

2. **For EACH test file you want to create**:
   - Announce: "I want to create test file [filename]"
   - Show the test code
   - **WAIT FOR USER APPROVAL**

3. **For EACH test command you want to run**:
   - Show: "I will run: [command]"
   - Explain: "This will test: [description]"
   - **WAIT FOR USER APPROVAL**

4. **If tests fail**:
   - Report failures immediately
   - ASK USER: "Should I investigate? Send back to Worker? Or continue?"

---

**🛑 MULTIPLE USER APPROVAL CHECKPOINTS**

During Tester execution:
- Approve testing strategy first
- Approve each test file creation
- Approve each test execution
- Answer questions about expected behavior
- Decide on failures: fix or continue

After testing complete, **USER MUST**:
- Review test results
- Understand all issues found
- Approve: "Testing approved, proceed to Security"

**DO NOT PROCEED TO SECURITY WITHOUT EXPLICIT USER APPROVAL!**

---

## Phase 5: Security Review (security)

**Only after user approves test results:**

Use the security subagent to:

1. Analyze git changes (git diff)
2. Search for vulnerabilities (OWASP Top 10)
3. Check for hardcoded secrets
4. Validate authentication/authorization
5. Check dependencies for CVEs
6. Rate issues by severity
7. Provide recommendations

**⚠️ SECURITY RULES**:
- You may ONLY read files and run git commands
- If you find issues, explain impact clearly
- Provide code examples for fixes
- If clarification needed, ASK THE USER
- End with: DECISION: APPROVED / APPROVED_WITH_CONDITIONS / NOT_APPROVED / BLOCKED

---

**🛑 FINAL WORKFLOW APPROVAL CHECKPOINT**

After Security completes, **USER MUST**:
1. Review security audit report
2. Understand all vulnerabilities found
3. Review recommendations
4. Make final decision:
   - 🟢 "APPROVED - Proceed to Deployer!" (no critical issues)
   - 🟡 "APPROVED WITH CONDITIONS - Deploy with monitoring"
   - 🟠 "NOT APPROVED - Fix issues first"
   - 🔴 "BLOCKED - Critical security issues, cannot deploy"

**DO NOT PROCEED TO DEPLOYER WITHOUT EXPLICIT USER APPROVAL!**

---

## Phase 6: Deployment (deployer)

**Only after user approves security audit:**

Use the deployer subagent to:

1. Review changes to commit
2. Create commit message (Conventional Commits format)
3. **SHOW proposed commit message and files to user**
4. **WAIT FOR USER APPROVAL**: "approve commit"
5. Create commit
6. Optionally: push to remote, create PR

**⚠️ DEPLOYER RULES**:
- **MANDATORY**: Get user approval before creating commit
- Follow Conventional Commits format
- Show git diff before committing
- Verify no secrets are being committed
- Can create PR using `gh` CLI (with approval)

**Note**: For git information (history, conflicts, help), use **git-helper** agent instead.

---

**🛑 DEPLOYMENT APPROVAL CHECKPOINT**

Deployer will:
1. Show proposed commit message
2. Show files to be committed
3. Show git diff
4. **WAIT for "approve commit"**
5. Execute commit
6. Report commit SHA

After deployment complete:
- Deployer reports commit created
- User can request push to remote
- User can request PR creation

---

## Optional: Post-Workflow Documentation

After successful deployment, you may want to:

### 1. Save Solution to Knowledge Base (knowledge-keeper)

If this was a complex problem with a reusable solution:

```
"knowledge-keeper: Validate and save this solution

Problem: [description]
Solution: [what was done]
Context: [global/project]
"
```

knowledge-keeper will:
- Validate solution accuracy
- Check sources are authoritative
- Save to `.claude/knowledge/` (global or project)
- Create ADR if it's an architectural decision

### 2. Create Documentation (technical-writer)

For user-facing documentation:

```
"technical-writer: Create implementation report for [feature]

Include:
- What was built
- Why it matters
- How to use it
- Examples
"
```

technical-writer will:
- Create detailed documentation in `docs/` or `.claude/archives/`
- Call obsidian-agent to create summary in Obsidian vault
- Link Obsidian note to detailed project docs

### 3. Create ADR (knowledge-keeper)

For significant architectural decisions:

```
"knowledge-keeper: Create ADR for decision to use [technology]

Context: [problem and constraints]
Decision: [what was chosen]
Alternatives: [what was considered]
"
```

### 4. Save Completion Report to Diary

**IMPORTANT**: After completing ANY task and providing final message to user, save a brief completion report to Obsidian diary for communication history.

**Location**: `~/Obsidian/Work_with_claude/01-Diary/`

**Filename format**: `YYYY-MM-DD-HH-MM-brief-description.md`
- Use current timestamp
- Maximum 4 words for description
- Lowercase, hyphen-separated

**Example**:
```bash
# Get current timestamp
TIMESTAMP=$(date +"%Y-%m-%d-%H-%M")
# Create: 2025-10-22-14-30-hyprland-monitor-setup.md
```

**Report structure**:
```markdown
---
date: YYYY-MM-DD HH:MM
type: completion-report
tags: [relevant, tags, here]
status: completed
---

# Brief Title (4 words max)

## Задание
[User's request - 1-2 sentences]

## Что сделано
- Action 1
- Action 2
- Action 3

## Результат
[Final outcome - 1-2 sentences]

## Файлы
- `file/path/1`
- `file/path/2`

## Команды
```bash
command 1
command 2
```

## Теги
#tag1 #tag2 #tag3

---
*Agent: claude*
```

**When to save**:
- ✅ After completing tasks with file changes
- ✅ After workflow completion (all phases done)
- ✅ After problem solving/troubleshooting
- ✅ After system configuration
- ✅ After creating documentation

**When NOT to save**:
- ❌ Simple Q&A without actions
- ❌ Reading files without changes
- ❌ Information search without results
- ❌ Incomplete tasks (in progress)

**See**: `~/.claude/claude.md` for detailed instructions on diary reports.

---

## Universal Agent Rules

**ALL AGENTS MUST**:

1. ✅ **ASK before ANY action that modifies system**
2. ✅ **ASK before running commands on server**
3. ✅ **ASK if encountering problems**
4. ✅ **ASK if needing to deviate from plan**
5. ✅ **ASK if requirements are unclear**
6. ❌ **NEVER assume user approval**
7. ❌ **NEVER skip user approval steps**
8. ❌ **NEVER make changes without explicit permission**

**USER HAS FINAL CONTROL OVER EVERYTHING!**

---

## Project-Specific Customization

This workflow can be customized per project using:

1. **Skills** - Project-specific workflows in `.claude/skills/`
2. **Project agents** - Override global agents in `.claude/agents/`
3. **Custom approval gates** - Add project-specific checkpoints
4. **Skip phases** - Not all projects need all phases (e.g., skip tester for docs-only changes)

Example project skill:
```markdown
# .claude/skills/quick-deploy.md
# Quick deploy workflow (skips tester for hotfixes)
planner → reviewer → worker → security → deployer
```

---

## Starting the Workflow

The Planner agent will now begin analyzing your request.

**Remember**: You will approve every critical decision throughout this workflow.

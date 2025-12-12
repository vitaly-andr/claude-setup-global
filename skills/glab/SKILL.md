---
name: glab
description: GitLab CLI (glab) for managing pipelines, jobs, and artifacts. Use when working with glab commands, downloading CI artifacts, or viewing pipeline status.
---

# glab - GitLab CLI

GitLab CLI commands for CI/CD pipeline management. Use when working with GitLab pipelines, jobs, and artifacts.

## Environment Setup

For self-hosted GitLab (gl.andrianoff.online):
```bash
export GITLAB_HOST=gl.andrianoff.online
```

## CI/CD Pipeline Commands

### List Pipelines
```bash
# List all pipelines (default: current repo)
glab ci list

# Filter by ref (branch/tag)
glab ci list --ref main
glab ci list -r feature/add-gitlab-ci

# Filter by status
glab ci list --status running
glab ci list -s failed

# Output as JSON
glab ci list --output json
```

### Pipeline Status
```bash
# Current branch status
glab ci status

# Specific branch status
glab ci status -b main
glab ci status --branch feature/add-gitlab-ci
```

### View Pipeline (Interactive TUI)
```bash
# View current branch pipeline
glab ci view

# View specific branch pipeline
glab ci view main
glab ci view -b feature/add-gitlab-ci

# View specific pipeline by ID
glab ci view -p 33
glab ci view --pipelineid 33

# Open in browser
glab ci view -w
```

### Trace Job Logs
```bash
# Interactive job selection (current branch)
glab ci trace

# Trace by job name
glab ci trace test
glab ci trace provision

# Trace specific branch job
glab ci trace test -b main
glab ci trace test --branch feature/add-gitlab-ci

# Trace by pipeline ID
glab ci trace test -p 33
glab ci trace test --pipeline-id 33

# Trace by job ID (numeric)
glab ci trace 224356863
```

### Run/Trigger Pipelines
```bash
# Run new pipeline on current branch
glab ci run

# Run on specific branch
glab ci run -b main

# Retry a job
glab ci retry <job-id>

# Trigger a manual job
glab ci trigger <job-id>
```

### Cancel Pipelines/Jobs
```bash
# Cancel pipeline
glab ci cancel

# Cancel specific pipeline
glab ci cancel <pipeline-id>
```

### Download Artifacts
```bash
# DEPRECATED: glab ci artifact is deprecated, use glab job artifact
glab job artifact <ref> <job-name>

# Download artifacts from test job to current directory
glab job artifact main test

# Download to specific path
glab job artifact main test --path="/tmp/artifacts/"

# List paths in artifact without downloading
glab job artifact main test --list-paths

# Examples for my-OpenProject (must be in project dir):
cd ~/Projects/my-OpenProject
glab job artifact fix/enterprise-bypass-feature-tests test --path="/tmp/ci-artifacts/"
```

### View Pipeline Jobs via API
```bash
# List jobs in a pipeline (to find job IDs)
glab api projects/2/pipelines/<PIPELINE_ID>/jobs | jq '.[] | {id, name, status}'

# Get artifacts info
glab api projects/2/pipelines/<PIPELINE_ID>/jobs | jq '.[] | {id, name, artifacts_file}'
```

### Get Pipeline JSON
```bash
# Get current branch pipeline as JSON
glab ci get

# Get specific branch
glab ci get -b main
```

### Lint CI Config
```bash
# Lint .gitlab-ci.yml
glab ci lint
```

## Common Patterns

### Monitor Pipeline Progress
```bash
# Watch pipeline status
watch -n 5 'glab ci status'

# Stream job logs in real-time
glab ci trace test -b feature/add-gitlab-ci
```

### Check Failed Pipeline
```bash
# List failed pipelines
glab ci list -s failed

# Trace the failed job
glab ci trace <job-name> -p <pipeline-id>
```

## Flag Reference

| Short | Long | Description |
|-------|------|-------------|
| -b | --branch | Branch name |
| -p | --pipeline-id / --pipelineid | Pipeline ID |
| -r | --ref | Git ref (branch/tag) |
| -s | --status | Pipeline status filter |
| -R | --repo | Repository (OWNER/REPO) |
| -w | --web | Open in browser |
| -o | --output | Output format (text/json) |

## Important Notes

1. `-b` in `glab ci list` is `--updated-before` (date), NOT branch! Use `-r` or `--ref` for branch filtering.
2. `-b` in `glab ci trace`, `glab ci status`, `glab ci view` IS branch.
3. Always run from within the git repo directory.
4. Set `GITLAB_HOST` for self-hosted GitLab.

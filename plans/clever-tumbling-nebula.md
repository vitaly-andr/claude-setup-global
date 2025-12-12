# Consolidated Feature Execution Plan

**Date**: 2025-12-10

## WORKFLOW (STRICT)

```
┌──────────────────────────────────────┐
│ 1. I implement ONE phase             │
├──────────────────────────────────────┤
│ 2. I run automated tests             │
├──────────────────────────────────────┤
│ 3. I STOP and show you results       │
├──────────────────────────────────────┤
│ 4. YOU manually test (prompt agent)  │
├──────────────────────────────────────┤
│ 5. YOU say "approved" or "fix X"     │
├──────────────────────────────────────┤
│ 6. ONLY THEN I proceed to next phase │
└──────────────────────────────────────┘
```

**I will NOT continue to the next phase without your explicit approval.**

---

## Current State Assessment

### Files That EXIST (status UNKNOWN until tested)

| Component | File Exists | Verified Working |
|-----------|-------------|------------------|
| `src/models/feedback.py` | ❌ NO | - |
| `src/embedding/embedding_service.py` | YES | ❓ NOT YET TESTED |
| `src/weaviate/client.py` | YES | ❓ NOT YET TESTED |
| `src/feedback/storage.py` | YES | ❓ NOT YET TESTED |
| `src/feedback/collector.py` | YES | ❓ NOT YET TESTED |
| `src/feedback/processor.py` | YES | ❓ NOT YET TESTED |
| `src/agents/knowledge_keeper.py` | YES | ❓ NOT YET TESTED |
| `src/servers/shared.py` | YES | ❓ NOT YET TESTED |
| `src/servers/feedback/mcp_server.py` | YES | ❓ NOT YET TESTED |
| `src/servers/search/mcp_server.py` | YES | ❓ NOT YET TESTED |
| `src/servers/curation/mcp_server.py` | YES | ❓ NOT YET TESTED |
| `src/servers/workflow/mcp_server.py` | YES | ❓ NOT YET TESTED |

**NOTHING is considered "working" until YOU approve it after testing.**

---

## FEATURE 004: MCP Server Split - Phases

### PHASE 1: Create Missing Models
**What**: Create `src/models/feedback.py` with Solution, SolutionStatus, FeedbackEntry, FeedbackOutcome
**Files**: `src/models/feedback.py` (NEW)
**Auto-test**: `uv run python -c "from src.models.feedback import Solution, SolutionStatus, FeedbackEntry, FeedbackOutcome; print('OK')"`
**Manual test**: You verify import works
**STOP**: Wait for your approval

---

### PHASE 2: Verify Embedding Service
**What**: Verify `src/embedding/embedding_service.py` works
**Files**: None (verification only)
**Auto-test**: `uv run python -c "from src.embedding import EmbeddingService; e = EmbeddingService(); print(e.embed('test'))"`
**Manual test**: You run embedding on sample text, verify 384-dim vector returned
**STOP**: Wait for your approval

---

### PHASE 3: Verify Weaviate Client
**What**: Verify `src/weaviate/client.py` works
**Files**: None (verification only)
**Auto-test**: Run Weaviate-related tests
**Manual test**: You verify Weaviate connection, CRUD operations
**STOP**: Wait for your approval

---

### PHASE 4: Verify Feedback Storage
**What**: Verify `src/feedback/storage.py` works
**Files**: None (verification only)
**Auto-test**: Run feedback storage tests
**Manual test**: You store/retrieve feedback, verify persistence
**STOP**: Wait for your approval

---

### PHASE 5: Verify Feedback Collector
**What**: Verify `src/feedback/collector.py` works
**Files**: None (verification only)
**Auto-test**: Run collector tests
**Manual test**: You submit feedback via collector, verify validation
**STOP**: Wait for your approval

---

### PHASE 6: Verify Feedback Processor
**What**: Verify `src/feedback/processor.py` works
**Files**: None (verification only)
**Auto-test**: Run processor tests
**Manual test**: You process feedback, verify quality scores
**STOP**: Wait for your approval

---

### PHASE 7: Verify Knowledge Keeper
**What**: Verify `src/agents/knowledge_keeper.py` works
**Files**: None (verification only)
**Auto-test**: Run knowledge keeper tests
**Manual test**: You run curation, verify categorization
**STOP**: Wait for your approval

---

### PHASE 8: Verify Shared Services
**What**: Verify `src/servers/shared.py` works
**Files**: None (verification only)
**Auto-test**: `pytest tests/servers/test_shared.py -v`
**Manual test**: You verify all singletons initialize correctly
**STOP**: Wait for your approval

---

### PHASE 9: Verify Feedback MCP Server
**What**: Verify `src/servers/feedback/mcp_server.py` works
**Files**: None (verification only)
**Auto-test**: `pytest tests/servers/test_feedback_server.py -v`
**Manual test**: You start server, call submit_feedback tool
**STOP**: Wait for your approval

---

### PHASE 10: Verify Search MCP Server
**What**: Verify `src/servers/search/mcp_server.py` works
**Files**: None (verification only)
**Auto-test**: `pytest tests/servers/test_search_server.py -v`
**Manual test**: You start server, call suggest_solutions tool
**STOP**: Wait for your approval

---

### PHASE 11: Verify Curation MCP Server
**What**: Verify `src/servers/curation/mcp_server.py` works
**Files**: None (verification only)
**Auto-test**: `pytest tests/servers/test_curation_server.py -v`
**Manual test**: You start server, call curate_solutions tool
**STOP**: Wait for your approval

---

### PHASE 12: Verify Workflow MCP Server
**What**: Verify `src/servers/workflow/mcp_server.py` works
**Files**: None (verification only)
**Auto-test**: `pytest tests/servers/test_workflow_server.py -v`
**Manual test**: You start server, call get_workflow_status tool
**STOP**: Wait for your approval

---

### PHASE 13: Add Health Checks to All Servers
**What**: Add `/health` endpoint to all 4 servers
**Files**: All 4 mcp_server.py files
**Auto-test**: pytest for each server
**Manual test**: You call health endpoint on each server
**STOP**: Wait for your approval

---

### PHASE 14: Startup Script
**What**: Create script to start all 4 servers
**Files**: `src/servers/start_all.py` (NEW)
**Auto-test**: Script runs without error
**Manual test**: You run script, verify all servers start
**STOP**: Wait for your approval

---

### PHASE 15: Agent Configuration
**What**: YAML mapping agents to servers
**Files**: `src/config/agents.yaml` (NEW)
**Auto-test**: pytest tests/servers/test_agent_config.py
**Manual test**: You verify config loads, mappings correct
**STOP**: Wait for your approval

---

### PHASE 16: Token Measurement
**What**: Utility to measure tool description tokens
**Files**: `src/servers/measure_tokens.py` (NEW)
**Auto-test**: Script runs, outputs measurements
**Manual test**: You verify 25%+ reduction for worker, 60%+ for orchestrator
**STOP**: Wait for your approval

---

### PHASE 17: Fallback Mode
**What**: MCP_SERVER_MODE env variable handling
**Files**: `src/config/server_mode.py` (NEW)
**Auto-test**: pytest tests/servers/test_fallback_mode.py
**Manual test**: You test switching modes
**STOP**: Wait for your approval

---

### PHASE 18: Feature 004 Final
**What**: Run all tests, verify success criteria SC-001 through SC-008
**Files**: None
**Auto-test**: Full test suite
**Manual test**: You verify all success criteria met
**STOP**: Wait for your approval to close Feature 004

---

---

## FEATURE 005: PersInMa (After 004 Complete)

### PHASE 19: PersInMa Setup
**What**: Create `src/pers_in_ma/` directory structure
**Files**: `src/pers_in_ma/__init__.py`, `src/pers_in_ma/mcp_server.py`
**Auto-test**: Import works
**Manual test**: You verify structure exists
**STOP**: Wait for your approval

---

### PHASE 20: Storage Layer
**What**: Weaviate schema for PersInMa_Documents
**Files**: `src/pers_in_ma/storage.py`
**Auto-test**: pytest tests/pers_in_ma/test_storage.py
**Manual test**: You verify collection created
**STOP**: Wait for your approval

---

### PHASE 21: Chunking
**What**: Text chunker with tiktoken
**Files**: `src/pers_in_ma/chunker.py`
**Auto-test**: pytest tests/pers_in_ma/test_chunker.py
**Manual test**: You verify chunking works
**STOP**: Wait for your approval

---

### PHASE 22: PDF Processor (US1)
**What**: Extract text from PDFs with Claude vision
**Files**: `src/pers_in_ma/processors/pdf.py`
**Auto-test**: pytest tests/pers_in_ma/test_processors/test_pdf.py
**Manual test**: You ingest a PDF, verify extraction
**STOP**: Wait for your approval

---

### PHASE 23: Markdown Processor (US1)
**What**: Parse markdown with frontmatter
**Files**: `src/pers_in_ma/processors/markdown.py`
**Auto-test**: pytest tests/pers_in_ma/test_processors/test_markdown.py
**Manual test**: You ingest markdown, verify parsing
**STOP**: Wait for your approval

---

### PHASE 24: DOCX Processor (US1)
**What**: Extract text from DOCX
**Files**: `src/pers_in_ma/processors/docx.py`
**Auto-test**: pytest tests/pers_in_ma/test_processors/test_docx.py
**Manual test**: You ingest DOCX, verify extraction
**STOP**: Wait for your approval

---

### PHASE 25: Q&A Agent (US1)
**What**: RAG agent for answering questions
**Files**: `src/pers_in_ma/qa_agent.py`
**Auto-test**: pytest tests/pers_in_ma/test_qa_agent.py
**Manual test**: You ask question about ingested file
**STOP**: Wait for your approval

---

### PHASE 26: US1 MCP Tools
**What**: ingest_file, search, ask tools
**Files**: `src/pers_in_ma/mcp_server.py`
**Auto-test**: pytest tests/pers_in_ma/test_mcp_server.py
**Manual test**: You call tools via MCP
**STOP**: Wait for your approval

---

### PHASE 27: Image Processor (US2)
**What**: Screenshot analysis with Claude vision
**Files**: `src/pers_in_ma/processors/image.py`
**Auto-test**: pytest tests/pers_in_ma/test_processors/test_image.py
**Manual test**: You ingest screenshot, ask about it
**STOP**: Wait for your approval

---

### PHASE 28: Audio Processor (US3)
**What**: Transcription with faster-whisper
**Files**: `src/pers_in_ma/processors/audio.py`
**Auto-test**: pytest tests/pers_in_ma/test_processors/test_audio.py
**Manual test**: You ingest audio, search transcript
**STOP**: Wait for your approval

---

### PHASE 29: Document Processor (US4)
**What**: Folder batch ingestion
**Files**: `src/pers_in_ma/document_processor.py`
**Auto-test**: pytest tests/pers_in_ma/test_document_processor.py
**Manual test**: You ingest folder, query across files
**STOP**: Wait for your approval

---

### PHASE 30: Obsidian Support (US5)
**What**: Obsidian vault integration
**Files**: Update `src/pers_in_ma/processors/markdown.py`
**Auto-test**: pytest tests specific to Obsidian
**Manual test**: You ingest Obsidian vault
**STOP**: Wait for your approval

---

### PHASE 31: Web Processor (US6)
**What**: URL fetching and extraction
**Files**: `src/pers_in_ma/processors/web.py`
**Auto-test**: pytest tests/pers_in_ma/test_processors/test_web.py
**Manual test**: You ingest URL, ask about content
**STOP**: Wait for your approval

---

### PHASE 32: Source Management (US7)
**What**: list_sources, delete_source tools
**Files**: `src/pers_in_ma/mcp_server.py`
**Auto-test**: pytest tests/pers_in_ma/test_source_management.py
**Manual test**: You list and delete sources
**STOP**: Wait for your approval

---

### PHASE 33: Feature 005 Final
**What**: Error handling, performance validation
**Files**: Various
**Auto-test**: Full PersInMa test suite
**Manual test**: You verify all success criteria
**STOP**: Wait for your approval to close 005

---

## FEATURE 006: Complete RAG Infrastructure

Based on verification, Feature 006 is 95% complete. Only missing piece:

### PHASE 34: Verify 006 Status
**What**: Confirm all 006 modules work
**Files**: None (verification only)
**Auto-test**: Run tests for feedback, embedding, weaviate, agents
**Manual test**: You confirm feature complete
**STOP**: Wait for your approval to close 006

---

## Execution Order

**Feature 004** (Phases 1-18) → **Feature 005** (Phases 19-33) → **Feature 006** (Phase 34)

Each phase: Implement/Test → Auto-test → STOP → You manually test → You approve → Next phase

---

## Summary

| Feature | Phases | Description |
|---------|--------|-------------|
| 004 MCP Server Split | 1-18 | Create models, verify all components, add health checks, config |
| 005 PersInMa | 19-33 | Document Q&A system with all processors |
| 006 RAG Infrastructure | 34 | Final verification |

**Total**: 34 phases, each requiring your approval before proceeding.

**FIRST PHASE**: Create `src/models/feedback.py` - ready to start when you approve this plan.

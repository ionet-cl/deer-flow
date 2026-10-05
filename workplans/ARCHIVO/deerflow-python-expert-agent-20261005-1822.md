# Workplan: deerflow-python-expert-agent

**Created:** 2026-10-05 18:22
**Target:** DeerFlow (`config.yaml`, `backend/.deer-flow/agents/python-expert/`, `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/python-expert/`)
**Investigaciones consulted:** DeerFlow Subagents Registry (`packages/harness/deerflow/subagents/AGENTS.md`), Custom Agent Loaders (`packages/harness/deerflow/config/agents_config.py`), Factory Metamethodology & Worktree Protocol, Hermetic Testing Protocol.

## Regime

**Regime:** Deterministic (Bohrbug) — Subagent configurations and agent on-disk definitions are deterministic schema-validated YAML and Markdown files.

## Pareto Focus

The 20% of touchpoints carrying the 80% of impact:

| # | Touchpoint | Impact if fixed | Effort | Rank |
|---|---|---|---|---|
| 1 | Register `subagents.custom_agents.python-expert` in `config.yaml` | Enables Lead Agent (`looper-boss`) to delegate Python systems architecture, strict typing, and implementation tasks via `task` tool | Low | 1 |
| 2 | Create on-disk agent definitions in `backend/.deer-flow/agents/python-expert/` | Exposes `python-expert` in global template directory for fallback resolution and schema validation | Low | 2 |
| 3 | Replicate definitions to active user agent store (`18106577-16b4-4fca-96ee-8f57a56c75f1`) | Ensures user-isolation layout resolves agent seamlessly via FileAgentStore | Low | 3 |
| 4 | Container reload & verification (FileAgentStore & REST API) | Proves `python-expert` is discovered, valid, and operational across container boundary | Low | 4 |

## Root Cause — 5 Whys (Deterministic (Bohrbug) regime only)

1. **What fails:** DeerFlow lacks a dedicated Python software architect and systems engineering specialist agent in its subagent registry.
2. **Why:** Previous agent registration focused on research triad (`empirical-researcher`, `slop-sanitizer`, `research-consolidator`), lead agent governance, and Go systems engineering (`go-expert`).
3. **Why:** Python tasks were falling back to generic subagents without strict typing (mypy/pyright), hermetic TDD, async/await discipline, or automated workspace hygiene.
4. **Why:** High-performance and robust Python services require strict typing contracts, AST simplicity guards, and hermetic testing without internal logic mocks.
5. **Why:** Establishing a dedicated `python-expert` agent with explicit invariants, workspace hygiene protocols, and closed failure ladders ensures deterministic, zero-debt Python code.

**Refuting prediction:** If `FileAgentStore.list_custom_agents()` or `/api/agents` fails to return `python-expert`, or if `SOUL.md` lacks the Workspace Hygiene section, the configuration is invalid.

**Invariant to create:** The `python-expert` specialist is fully registered in `config.yaml`, persisted on disk in template and active user stores with `1003:1003` ownership, and verifiable via container API.

## NO-MAGIK ledger

| Element | Evidence class | Anchor / PENDING MEAS-xx |
|---|---|---|
| AST Cyclomatic complexity limit | SPECIFICATION | `MEAS-PY-01` (cyclomatic complexity <= 7) |
| Type annotation coverage | SPECIFICATION | `MEAS-PY-02` (type coverage 100%) |
| Test pass rate | SPECIFICATION | `MEAS-PY-03` (test pass rate 100%) |
| AST Function length limit | SPECIFICATION | Function length <= 40 lines |
| AST Nesting depth limit | SPECIFICATION | Nesting depth <= 2 levels |
| Subagent max turns | SPECIFICATION | 60 turns |
| Subagent timeout | SPECIFICATION | 1200 seconds |

## Invariants

- DRY: Consistent YAML configuration and SOUL prompt across `config.yaml` and on-disk stores.
- SOLID / SRP: `python-expert` specializes exclusively in Python systems architecture, strict typing, hermetic TDD, and clean workspace hygiene.
- Parse, Don't Validate: Domain states modeled via Pydantic v2, dataclasses, and typing.Annotated so invalid domain states are unrepresentable at compile and instantiation time.
- Workspace Hygiene: Compulsory safe cleanup of ephemeral build and cache artifacts (`__pycache__/`, `*.pyc`, `.pytest_cache/`, `.mypy_cache/`, `.ruff_cache/`, `.coverage`, etc.) leaving workspace clean.
- Poka-Yoke: Schema and REST API assertions verify registration end-to-end.

---

## Phase 1: Register Custom Subagent in `config.yaml`

**Goal:** Configure `subagents.custom_agents.python-expert` in `/home/leodev/repos/deer-flow/config.yaml`.

- [x] Task 1.1: Add `python-expert` to `subagents.custom_agents` with description, system_prompt, tools, skills, model, max_turns, and timeout_seconds.

**Acceptance:** `docker exec deer-flow-gateway python -c "from deerflow.config.app_config import get_app_config; cfg = get_app_config(); assert 'python-expert' in cfg.subagents.custom_agents; print('PHASE 1 ACCEPTED')"`
**Commit:** gitignored `config.yaml`

## Phase 2: Create On-Disk Custom Agent in `.deer-flow/` Stores

**Goal:** Author `config.yaml` and `SOUL.md` in template and user directories, and set permissions.

- [x] Task 2.1: Create `backend/.deer-flow/agents/python-expert/config.yaml` and `SOUL.md`.
- [x] Task 2.2: Create `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/python-expert/config.yaml` and `SOUL.md`.
- [x] Task 2.3: Ensure permissions `1003:1003` on both directories.

**Acceptance:** `docker exec deer-flow-gateway python -c "from app.gateway.agent_store import FileAgentStore; store = FileAgentStore(); agents = store.list_custom_agents(user_id='18106577-16b4-4fca-96ee-8f57a56c75f1'); names = [a.name for a in agents]; assert 'python-expert' in names; soul = store.load_agent_soul('python-expert', user_id='18106577-16b4-4fca-96ee-8f57a56c75f1'); assert 'Workspace Hygiene' in soul; print('PHASE 2 ACCEPTED')"`
**Commit:** gitignored `.deer-flow/`

## Phase 3: Verification & Gateway Endpoints

**Goal:** Verify live agent discovery via FileAgentStore and REST API.

- [x] Task 3.1: Test FileAgentStore discovery and SOUL verification inside container.
- [x] Task 3.2: Query `/api/agents` via internal token and assert `"name":"python-expert"`.

**Acceptance:** `TOKEN=$(docker exec deer-flow-gateway python -c 'from app.gateway.internal_auth import _load_internal_auth_token; print(_load_internal_auth_token())') && curl -sL -H "X-DeerFlow-Internal-Token: $TOKEN" http://127.0.0.1:2026/api/agents | grep -q '"name":"python-expert"' && echo "PHASE 3 ACCEPTED"`
**Commit:** verified live against gateway

---

## Closeout

- [x] 100% of phases committed and green
- [x] Workplan moved to `workplans/ARCHIVO/deerflow-python-expert-agent-20261005-1822.md`
- [x] Evidence recorded below
- [x] User notified via `notify-user`

**Evidence:**
- `config.yaml`: `subagents.custom_agents.python-expert` registered with full system prompt, invariants, AST simplicity limits, hermetic testing rules, workspace hygiene protocol, and closed failure ladder.
- On-disk directories: `backend/.deer-flow/agents/python-expert/` and `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/python-expert/` created with `config.yaml` and `SOUL.md`, owned by `1003:1003`.
- FileAgentStore verification passed:
  ```text
  SUCCESS: FileAgentStore verification passed for python-expert
  ```
- REST API verification passed:
  ```text
  TOKEN=$(docker exec deer-flow-gateway python -c 'from app.gateway.internal_auth import _load_internal_auth_token; print(_load_internal_auth_token())')
  curl -sL -H "X-DeerFlow-Internal-Token: $TOKEN" http://127.0.0.1:2026/api/agents | grep -o '"name":"python-expert"'
  "name":"python-expert"
  ```

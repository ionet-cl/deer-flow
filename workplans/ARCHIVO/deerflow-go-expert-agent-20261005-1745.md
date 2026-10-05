# Workplan: deerflow-go-expert-agent

**Created:** 2026-10-05 17:45
**Target:** DeerFlow (`config.yaml`, `backend/.deer-flow/agents/go-expert/`, `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/go-expert/`)
**Investigaciones consulted:** DeerFlow Subagents Registry (`packages/harness/deerflow/subagents/AGENTS.md`), Custom Agent Loaders (`packages/harness/deerflow/config/agents_config.py`), Factory Metamethodology & Worktree Protocol, Hermetic Testing Protocol.

## Regime

**Regime:** Deterministic (Bohrbug) — Subagent configurations and agent on-disk definitions are deterministic schema-validated YAML and Markdown files.

## Pareto Focus

The 20% of touchpoints carrying the 80% of impact:

| # | Touchpoint | Impact if fixed | Effort | Rank |
|---|---|---|---|---|
| 1 | Register `subagents.custom_agents.go-expert` in `config.yaml` | Enables Lead Agent (`looper-boss`) to delegate Go systems architecture and implementation tasks via `task` tool | Low | 1 |
| 2 | Create on-disk agent definitions in `backend/.deer-flow/agents/go-expert/` | Exposes `go-expert` in global template directory for fallback resolution and schema validation | Low | 2 |
| 3 | Replicate definitions to active user agent store (`18106577-16b4-4fca-96ee-8f57a56c75f1`) | Ensures user-isolation layout resolves agent seamlessly via FileAgentStore | Low | 3 |
| 4 | Container reload & verification (FileAgentStore & REST API) | Proves `go-expert` is discovered, valid, and operational across container boundary | Low | 4 |

## Root Cause — 5 Whys (Deterministic (Bohrbug) regime only)

1. **What fails:** DeerFlow lacks a dedicated Go systems engineering and craftsmanship specialist agent in its subagent registry.
2. **Why:** Previous agent registration focused on research triad (`empirical-researcher`, `slop-sanitizer`, `research-consolidator`) and lead agent governance.
3. **Why:** Go engineering tasks were previously falling back to generic subagents without strict silicon invariants (byte-exact CAS, path jail, raw-string lexical guard, zero-alloc benchmarks).
4. **Why:** High-performance Go services require strict stdlib-first discipline, AST simplicity guards, and hermetic testing without mocks.
5. **Why:** Establishing a dedicated `go-expert` agent with explicit invariants, workspace hygiene protocols, and closed failure ladders ensures deterministic, zero-slop systems code.

**Refuting prediction:** If `FileAgentStore.list()` or `/api/agents` fails to return `go-expert`, or if `SOUL.md` lacks the Workspace Hygiene section, the configuration is invalid.

**Invariant to create:** The `go-expert` specialist is fully registered in `config.yaml`, persisted on disk in template and active user stores with `1003:1003` ownership, and verifiable via container API.

## NO-MAGIK ledger

| Element | Evidence class | Anchor / PENDING MEAS-xx |
|---|---|---|
| AST Function length limit | SPECIFICATION | `MEAS-GO-01` (lines <= 40 per func) |
| AST Nesting depth limit | SPECIFICATION | `MEAS-GO-02` (nesting <= 2 levels) |
| AST Mutation test score | SPECIFICATION | `MEAS-GO-03` (mutation score >= 85%) |
| Subagent max turns | SPECIFICATION | 60 turns |
| Subagent timeout | SPECIFICATION | 1200 seconds |

## Invariants

- DRY: Consistent YAML configuration and SOUL prompt across `config.yaml` and on-disk stores.
- SOLID / SRP: `go-expert` specializes exclusively in Go systems craftsmanship, zero-alloc paths, and hermetic testing.
- Parse, Don't Validate: Domain states modeled so invalid states are unrepresentable at compile time.
- Workspace Hygiene: Compulsory safe cleanup of ephemeral build artifacts (`*.test`, `coverage.txt`, `pprof.*`, etc.) leaving workspace clean.
- Poka-Yoke: Schema and REST API assertions verify registration end-to-end.

---

## Phase 1: Register Custom Subagent in `config.yaml`

**Goal:** Configure `subagents.custom_agents.go-expert` in `/home/leodev/repos/deer-flow/config.yaml`.

- [x] Task 1.1: Add `go-expert` to `subagents.custom_agents` with description, system_prompt, tools, skills, model, max_turns, and timeout_seconds.

**Acceptance:** `docker exec deer-flow-gateway /app/backend/.venv/bin/python -c "from deerflow.config.app_config import get_app_config; cfg = get_app_config(); assert 'go-expert' in cfg.subagents.custom_agents; print('PHASE 1 ACCEPTED')"`
**Commit:** gitignored `config.yaml`

## Phase 2: Create On-Disk Custom Agent in `.deer-flow/` Stores

**Goal:** Author `config.yaml` and `SOUL.md` in template and user directories, and set permissions.

- [x] Task 2.1: Create `backend/.deer-flow/agents/go-expert/config.yaml` and `SOUL.md`.
- [x] Task 2.2: Create `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/go-expert/config.yaml` and `SOUL.md`.
- [x] Task 2.3: Ensure permissions `1003:1003` on both directories.

**Acceptance:** `docker exec deer-flow-gateway /app/backend/.venv/bin/python -c "from deerflow.config.agents_config import list_custom_agents, load_agent_soul; names = [a.name for a in list_custom_agents(user_id='18106577-16b4-4fca-96ee-8f57a56c75f1')]; assert 'go-expert' in names; soul = load_agent_soul('go-expert', user_id='18106577-16b4-4fca-96ee-8f57a56c75f1'); assert 'Workspace Hygiene' in soul; print('PHASE 2 ACCEPTED')"`
**Commit:** gitignored `.deer-flow/`

## Phase 3: Verification & Gateway Endpoints

**Goal:** Verify live agent discovery via FileAgentStore and REST API.

- [x] Task 3.1: Test FileAgentStore discovery and SOUL verification inside container.
- [x] Task 3.2: Query `/api/agents` via internal token and assert `"name":"go-expert"`.

**Acceptance:** `TOKEN=$(docker exec deer-flow-gateway python -c 'from app.gateway.internal_auth import _load_internal_auth_token; print(_load_internal_auth_token())') && curl -sL -H "X-DeerFlow-Internal-Token: $TOKEN" http://127.0.0.1:2026/api/agents | grep -q '"name":"go-expert"' && echo "PHASE 3 ACCEPTED"`
**Commit:** verified live against gateway

---

## Closeout

- [x] 100% of phases committed and green
- [x] Workplan moved to `workplans/ARCHIVO/deerflow-go-expert-agent-20261005-1745.md`
- [x] Evidence recorded below
- [x] User notified via `notify-user`

**Evidence:**
- `config.yaml`: `subagents.custom_agents.go-expert` registered with full system prompt, invariants (INV-01 through INV-23), AST guards, hermetic testing rules, workspace hygiene protocol, and closed failure ladder.
- On-disk directories: `backend/.deer-flow/agents/go-expert/` and `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/go-expert/` created with `config.yaml` and `SOUL.md`, owned by `1003:1003`.
- FileAgentStore verification passed:
  ```text
  SUCCESS: FileAgentStore verification passed for go-expert
  ```
- REST API verification passed:
  ```text
  TOKEN=$(docker exec deer-flow-gateway python -c 'from app.gateway.internal_auth import _load_internal_auth_token; print(_load_internal_auth_token())')
  curl -sL -H "X-DeerFlow-Internal-Token: $TOKEN" http://127.0.0.1:2026/api/agents | grep -o '"name":"go-expert"'
  "name":"go-expert"
  ```


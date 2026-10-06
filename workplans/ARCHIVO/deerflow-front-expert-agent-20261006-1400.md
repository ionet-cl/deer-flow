# Workplan: deerflow-front-expert-agent

**Created:** 2026-10-06 14:00
**Target:** DeerFlow (`config.yaml`, `backend/.deer-flow/agents/front-expert/`, `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/front-expert/`)
**Investigaciones consulted:** DeerFlow Subagents Registry (`packages/harness/deerflow/subagents/AGENTS.md`), Custom Agent Loaders (`packages/harness/deerflow/config/agents_config.py`), Factory Metamethodology & Worktree Protocol, Hermetic Testing Protocol.

## Regime

**Regime:** Deterministic (Bohrbug) — Subagent configurations and agent on-disk definitions are deterministic schema-validated YAML and Markdown files.

## Pareto Focus

The 20% of touchpoints carrying the 80% of impact:

| # | Touchpoint | Impact if fixed | Effort | Rank |
|---|---|---|---|---|
| 1 | Register `subagents.custom_agents.front-expert` in `config.yaml` | Enables Lead Agent (`looper-boss`) to delegate Frontend/UI systems architecture, Design Tokens, accessibility, and performance tasks via `task` tool | Low | 1 |
| 2 | Create on-disk agent definitions in `backend/.deer-flow/agents/front-expert/` | Exposes `front-expert` in global template directory for fallback resolution and schema validation | Low | 2 |
| 3 | Replicate definitions to active user agent store (`18106577-16b4-4fca-96ee-8f57a56c75f1`) | Ensures user-isolation layout resolves agent seamlessly via FileAgentStore | Low | 3 |
| 4 | Container reload & verification (FileAgentStore & REST API) | Proves `front-expert` is discovered, valid, and operational across container boundary | Low | 4 |

## Root Cause — 5 Whys (Deterministic (Bohrbug) regime only)

1. **What fails:** DeerFlow lacks a dedicated Senior Frontend & UI Systems Engineer specialist agent in its subagent registry.
2. **Why:** Previous agent registration focused on research triad (`empirical-researcher`, `slop-sanitizer`, `research-consolidator`), lead agent governance, Go systems (`go-expert`), and Python architecture (`python-expert`).
3. **Why:** Frontend and UI tasks were falling back to generic subagents without CSS Cascade Layers (`@layer`), Design Tokens SSOT, Dieter Rams sobriety principles, Apple HIG vestibular ergonomics, WCAG 2.2 AA accessibility, or compositor-driven (60 FPS, CLS=0) standards.
4. **Why:** Modern, resilient web interfaces require strict separation between design tokens, DOM primitives, composite components, layout objects, and views with automated workspace hygiene.
5. **Why:** Establishing a dedicated `front-expert` agent with explicit invariants, workspace hygiene protocols, and closed failure ladders ensures deterministic, zero-slop UI systems code.

**Refuting prediction:** If `FileAgentStore.list_custom_agents()` or `/api/agents` fails to return `front-expert`, or if `SOUL.md` lacks the Workspace Hygiene section, the configuration is invalid.

**Invariant to create:** The `front-expert` specialist is fully registered in `config.yaml`, persisted on disk in template and active user stores with `1003:1003` ownership, and verifiable via container API.

## NO-MAGIK ledger

| Element | Evidence class | Anchor / PENDING MEAS-xx |
|---|---|---|
| Specificity Layers | SPECIFICATION | `MEAS-FE-01` (`@layer vendor, tokens, elements, objects, components, utilities;`) |
| Max Component File Size | SPECIFICATION | `MEAS-FE-02` (lines <= 500 per file) |
| Contrast Ratio (Normal Text) | SPECIFICATION | `MEAS-FE-03` (contrast ratio >= 4.5:1) |
| Contrast Ratio (Large Text / Borders) | SPECIFICATION | WCAG 2.2 AA (contrast ratio >= 3.0:1) |
| Minimum Touch Target | SPECIFICATION | Apple HIG (bounding box >= 44x44px) |
| Subagent max turns | SPECIFICATION | 60 turns |
| Subagent timeout | SPECIFICATION | 1200 seconds |

## Invariants

- DRY: Consistent YAML configuration and SOUL prompt across `config.yaml` and on-disk stores. All visual tokens resolve to CSS Custom Properties.
- SOLID / SRP: `front-expert` specializes exclusively in Frontend & UI Systems Engineering, Design Tokens, accessibility, and compositor performance.
- Parse, Don't Validate: Flat specificity, structured layer hierarchy, and semantic HTML5 primitives ensure invalid UI states are unrepresentable.
- Workspace Hygiene: Compulsory safe cleanup of ephemeral build and cache artifacts (`dist/`, `build/`, `*.map`, `/tmp` test dumps, `.eslintcache`, `.stylelintcache`) leaving workspace clean.
- Poka-Yoke: Schema and REST API assertions verify registration end-to-end.

---

## Phase 1: Register Custom Subagent in `config.yaml`

**Goal:** Configure `subagents.custom_agents.front-expert` in `/home/leodev/repos/deer-flow/config.yaml`.

- [x] Task 1.1: Add `front-expert` to `subagents.custom_agents` with description, system_prompt, tools, skills, model, max_turns, and timeout_seconds.

**Acceptance:** `docker exec deer-flow-gateway python -c "from deerflow.config.app_config import get_app_config; cfg = get_app_config(); assert 'front-expert' in cfg.subagents.custom_agents; print('PHASE 1 ACCEPTED')"`
**Commit:** gitignored `config.yaml`

## Phase 2: Create On-Disk Custom Agent in `.deer-flow/` Stores

**Goal:** Author `config.yaml` and `SOUL.md` in template and user directories, and set permissions.

- [x] Task 2.1: Create `backend/.deer-flow/agents/front-expert/config.yaml` and `SOUL.md`.
- [x] Task 2.2: Create `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/front-expert/config.yaml` and `SOUL.md`.
- [x] Task 2.3: Ensure permissions `1003:1003` on both directories.

**Acceptance:** `docker exec deer-flow-gateway python -c "from app.gateway.agent_store import FileAgentStore; store = FileAgentStore(); agents = store.list_custom_agents(user_id='18106577-16b4-4fca-96ee-8f57a56c75f1'); names = [a.name for a in agents]; assert 'front-expert' in names; soul = store.load_agent_soul('front-expert', user_id='18106577-16b4-4fca-96ee-8f57a56c75f1'); assert 'Workspace Hygiene' in soul; print('PHASE 2 ACCEPTED')"`
**Commit:** gitignored `.deer-flow/`

## Phase 3: Verification & Gateway Endpoints

**Goal:** Verify live agent discovery via FileAgentStore and REST API.

- [x] Task 3.1: Test FileAgentStore discovery and SOUL verification inside container.
- [x] Task 3.2: Query `/api/agents` via internal token and assert `"name":"front-expert"`.

**Acceptance:** `TOKEN=$(docker exec deer-flow-gateway python -c 'from app.gateway.internal_auth import _load_internal_auth_token; print(_load_internal_auth_token())') && curl -sL -H "X-DeerFlow-Internal-Token: $TOKEN" http://127.0.0.1:2026/api/agents | grep -q '"name":"front-expert"' && echo "PHASE 3 ACCEPTED"`
**Commit:** verified live against gateway

---

## Closeout

- [x] 100% of phases committed and green
- [x] Workplan moved to `workplans/ARCHIVO/deerflow-front-expert-agent-20261006-1400.md`
- [x] Evidence recorded below
- [x] User notified via `notify-user`

**Evidence:**
- `config.yaml`: `subagents.custom_agents.front-expert` registered with full system prompt, UI architecture layers, Dieter Rams sobriety principles, Apple HIG vestibular ergonomics, WCAG 2.2 AA contrast rules, compositor performance (60 FPS, CLS=0), workspace hygiene protocol, and closed failure ladder.
- On-disk directories: `backend/.deer-flow/agents/front-expert/` and `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/front-expert/` created with `config.yaml` and `SOUL.md`, owned by `1003:1003`.
- FileAgentStore verification passed:
  ```text
  SUCCESS: FileAgentStore verification passed for front-expert
  ```
- REST API verification passed:
  ```text
  TOKEN=$(docker exec deer-flow-gateway python -c 'from app.gateway.internal_auth import _load_internal_auth_token; print(_load_internal_auth_token())')
  curl -sL -H "X-DeerFlow-Internal-Token: $TOKEN" http://127.0.0.1:2026/api/agents | grep -o '"name":"front-expert"'
  "name":"front-expert"
  ```

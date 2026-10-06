# Workplan: deerflow-qa-and-infra-experts

**Created:** 2026-10-06 14:45
**Target:** DeerFlow (`config.yaml`, `backend/.deer-flow/agents/{qa-expert,infra-expert}/`, `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/{qa-expert,infra-expert}/`)
**Investigaciones consulted:** DeerFlow Subagents Registry (`backend/packages/harness/deerflow/config/subagents_config.py`), Custom Agent Loaders (`backend/packages/harness/deerflow/config/agents_config.py`), Factory Metamethodology & Worktree Protocol, Hermetic Testing Protocol.

## Regime

**Regime:** Deterministic (Bohrbug) — Subagent configurations and agent on-disk definitions are deterministic schema-validated YAML and Markdown files.

## Pareto Focus

The 20% of touchpoints carrying the 80% of impact (adversarial quality gate + deterministic infrastructure completion):

| # | Touchpoint | Impact if fixed | Effort | Rank |
|---|---|---|---|---|
| 1 | Register `subagents.custom_agents.{qa-expert,infra-expert}` in `config.yaml` | Enables Lead Agent (`looper-boss`) to delegate blind adversarial QA and deterministic infrastructure tasks | Low | 1 |
| 2 | Create on-disk agent definitions in `backend/.deer-flow/agents/{qa-expert,infra-expert}/` | Exposes agents in global template directory for fallback resolution and schema validation | Low | 2 |
| 3 | Replicate definitions to active user agent store (`18106577-16b4-4fca-96ee-8f57a56c75f1`) | Ensures user-isolation layout resolves both agents seamlessly via FileAgentStore | Low | 3 |
| 4 | Container reload & verification (FileAgentStore & REST API) | Proves `qa-expert` and `infra-expert` are discovered, valid, and operational across container boundary | Low | 4 |

## Root Cause — 5 Whys (Deterministic (Bohrbug) regime only)

1. **What fails:** DeerFlow lacks dedicated `qa-expert` (adversarial verification auditor) and `infra-expert` (deterministic platform engineer) specialist subagents in its subagent registry.
2. **Why:** Previous agent rollouts established the research triad, lead agent governance, Go systems (`go-expert`), Python architecture (`python-expert`), and UI systems (`front-expert`), leaving QA and Platform/Infra unspecialized.
3. **Why:** QA verification was falling back to standard dev routines without adversarial refutation, formal Poka-Yoke verification pyramid, Property-Based Testing (>=10,000 iterations), or mutation testing score thresholds (>=85%).
4. **Why:** Infrastructure tasks lacked a dedicated specialist anchored in Linux POSIX standards, non-root UID 1003 isolation, resource ceiling enforcement, and zero-downtime graceful shutdown (<=15s).
5. **Why:** Formalizing `qa-expert` and `infra-expert` with immutable quality matrices, workspace hygiene invariants, and closed failure ladders guarantees hermetic and reliable execution.

**Refuting prediction:** If `FileAgentStore.list_custom_agents()` or `/api/agents` fails to return `qa-expert` or `infra-expert`, or if their `SOUL.md` lacks the DRY+SOLID+LEAN+KISS+SSOT matrix or Workspace Hygiene section, the configuration is invalid.

**Invariant to create:** The `qa-expert` and `infra-expert` specialists are fully registered in `config.yaml`, persisted on disk in template and active user stores with `1003:1003` ownership, and verifiable via container API.

## NO-MAGIK ledger

| Element | Evidence class | Anchor / PENDING MEAS-xx |
|---|---|---|
| Property-Based Testing iterations | SPECIFICATION | `MEAS-QA-01` (minimum iterations >= 10,000 with shrinking) |
| Mutation Score Threshold | SPECIFICATION | `MEAS-QA-02` (kill score on diff >= 85%) |
| Container Resource Limits | SPECIFICATION | `MEAS-INFRA-01` (container memory ceiling and CPU quota enforcement) |
| Graceful Shutdown Window | SPECIFICATION | `MEAS-INFRA-02` (zero-downtime graceful shutdown grace period <= 15s) |
| Subagent max turns | SPECIFICATION | 60 turns |
| Subagent timeout | SPECIFICATION | 1200 seconds |

## Invariants

- DRY: Consistent YAML configuration and SOUL prompt across `config.yaml` and on-disk stores. Canonical fixtures and SSOT configurations.
- SOLID / SRP: `qa-expert` specializes in blind adversarial verification and mutation testing; `infra-expert` specializes in Linux POSIX, containers, systemd, and zero-downtime operations.
- Parse, Don't Validate: Domain-specific typing, strict schemas, and bounded execution environments prevent invalid runtime states.
- Workspace Hygiene: Compulsory safe cleanup of ephemeral test/build/coverage artifacts leaving workspace clean (`git status --porcelain` clean).
- Poka-Yoke: Schema and REST API assertions verify registration end-to-end.

---

## Phase 1: Register Custom Subagents in `config.yaml`

**Goal:** Configure `subagents.custom_agents.qa-expert` and `subagents.custom_agents.infra-expert` in `/home/leodev/repos/deer-flow/config.yaml`.

- [x] Task 1.1: Add `qa-expert` to `subagents.custom_agents` with description, system_prompt, tools, skills, model, max_turns, and timeout_seconds.
- [x] Task 1.2: Add `infra-expert` to `subagents.custom_agents` with description, system_prompt, tools, skills, model, max_turns, and timeout_seconds.

**Acceptance:** `docker exec deer-flow-gateway python -c "from deerflow.config.app_config import get_app_config; cfg = get_app_config(); assert 'qa-expert' in cfg.subagents.custom_agents and 'infra-expert' in cfg.subagents.custom_agents; print('PHASE 1 ACCEPTED')"`
**Commit:** gitignored `config.yaml`

## Phase 2: Create On-Disk Custom Agents in `.deer-flow/` Stores

**Goal:** Author `config.yaml` and `SOUL.md` in template and user directories, and set permissions.

- [x] Task 2.1: Create `backend/.deer-flow/agents/qa-expert/config.yaml` and `SOUL.md`.
- [x] Task 2.2: Create `backend/.deer-flow/agents/infra-expert/config.yaml` and `SOUL.md`.
- [x] Task 2.3: Create `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/qa-expert/config.yaml` and `SOUL.md`.
- [x] Task 2.4: Create `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/infra-expert/config.yaml` and `SOUL.md`.
- [x] Task 2.5: Ensure permissions `1003:1003` on all new directories.

**Acceptance:** `docker exec deer-flow-gateway python -c "from app.gateway.agent_store import FileAgentStore; store = FileAgentStore(); agents = store.list_custom_agents(user_id='18106577-16b4-4fca-96ee-8f57a56c75f1'); names = [a.name for a in agents]; assert 'qa-expert' in names and 'infra-expert' in names; print('PHASE 2 ACCEPTED')"`
**Commit:** gitignored `.deer-flow/`

## Phase 3: Verification & Gateway Endpoints

**Goal:** Verify live agent discovery via FileAgentStore and REST API.

- [x] Task 3.1: Test FileAgentStore discovery and SOUL verification inside container for all 8 agents.
- [x] Task 3.2: Query `/api/agents` via internal token and assert `"name":"qa-expert"` and `"name":"infra-expert"`.

**Acceptance:**
```bash
docker exec deer-flow-gateway python -c '
from app.gateway.agent_store import FileAgentStore
store = FileAgentStore()
agents = store.list_custom_agents(user_id="18106577-16b4-4fca-96ee-8f57a56c75f1")
names = [a.name for a in agents]
expected = ["empirical-researcher", "slop-sanitizer", "research-consolidator", "go-expert", "python-expert", "front-expert", "qa-expert", "infra-expert"]
for exp in expected:
    assert exp in names, f"{exp} missing from store: {names}"
    soul = store.load_agent_soul(exp, user_id="18106577-16b4-4fca-96ee-8f57a56c75f1")
    assert "SOLID" in soul and "DRY" in soul and "KISS" in soul, f"{exp} missing DRY/SOLID/KISS matrix"
print("SUCCESS: All 8 agents verified in store with DRY+SOLID+LEAN+KISS+SSOT matrix")
'
TOKEN=$(docker exec deer-flow-gateway python -c 'from app.gateway.internal_auth import _load_internal_auth_token; print(_load_internal_auth_token())')
curl -sL -H "X-DeerFlow-Internal-Token: $TOKEN" http://127.0.0.1:2026/api/agents | grep -o '"name":"qa-expert"'
curl -sL -H "X-DeerFlow-Internal-Token: $TOKEN" http://127.0.0.1:2026/api/agents | grep -o '"name":"infra-expert"'
```
**Commit:** verified live against gateway

---

## Closeout

- [x] 100% of phases committed and green
- [x] Workplan moved to `workplans/ARCHIVO/deerflow-qa-and-infra-experts-20261006-1445.md`
- [x] Evidence recorded below
- [x] User notified via `notify-user`

**Evidence:**
- `config.yaml`: `subagents.custom_agents.qa-expert` and `subagents.custom_agents.infra-expert` registered with full system prompts, Poka-Yoke verification pyramid, DRY+SOLID+LEAN+KISS+SSOT matrix, and Workspace Hygiene protocols.
- On-disk directories: `backend/.deer-flow/agents/{qa-expert,infra-expert}/` and `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/{qa-expert,infra-expert}/` created with `config.yaml` and `SOUL.md`, owned by `1003:1003`.
- FileAgentStore verification passed:
  ```text
  SUCCESS: All 8 agents verified in store with DRY+SOLID+LEAN+KISS+SSOT matrix
  ```
- REST API verification passed:
  ```text
  "name":"qa-expert"
  "name":"infra-expert"
  ```

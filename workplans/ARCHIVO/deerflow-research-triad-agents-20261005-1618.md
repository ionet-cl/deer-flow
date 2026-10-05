# Workplan: deerflow-research-triad-agents

**Created:** 2026-10-05 16:18
**Target:** DeerFlow (subagents.custom_agents in `config.yaml` and on-disk agents in `.deer-flow/agents/`)
**Investigaciones consulted:** DeerFlow Subagents Registry (`packages/harness/deerflow/subagents/AGENTS.md`), Custom Agent Loaders (`packages/harness/deerflow/config/agents_config.py`), Empirical Research Protocol, AI Slop Sanitizer Specification, Research Consolidator SSOT Protocol.

## Regime

**Regime:** Deterministic (Bohrbug) — Subagent configurations and agent on-disk definitions are deterministic schema-validated YAML and Markdown files.

## Pareto Focus

The 20% of touchpoints carrying the 80% of impact:

| # | Touchpoint | Impact if fixed | Effort | Rank |
|---|---|---|---|---|
| 1 | Register `subagents.custom_agents` in `config.yaml` | Enables Lead Agent (`looper-boss`) to delegate to the triad via `task` tool | Low | 1 |
| 2 | Create on-disk agent definitions in `.deer-flow/agents/` | Exposes triad in DeerFlow UI dropdown and `/api/agents` endpoint | Low | 2 |
| 3 | Replicate definitions to active user agent store | Ensures user-isolation layout resolves agents seamlessly | Low | 3 |
| 4 | Container reload & verification | Proves all 3 agents are discovered, valid, and operational | Low | 4 |

## Root Cause — 5 Whys (Deterministic (Bohrbug) regime only)

1. **What fails:** DeerFlow only has built-in subagents (`general-purpose`, `bash`) and no specialized research pipeline agents.
2. **Why:** The subagent configuration in `config.yaml` had `custom_agents` commented out.
3. **Why:** Specialized agent profiles (Empirical Researcher, Slop Sanitizer, Research Consolidator) had not yet been registered.
4. **Why:** Initial setup focused on Lead Agent orchestration and token frugality first.
5. **Why:** The research workflow requires distinct cognitive responsibilities (exploration vs. lexical sanitization vs. first-principles arbitration) to prevent confirmation bias and cognitive overload.

**Refuting prediction:** If `FileAgentStore.list()` or `SubagentRegistry` fails to load the new agents, or if `config.yaml` validation fails on restart, the configuration is broken.

**Invariant to create:** The research triad (`empirical-researcher`, `slop-sanitizer`, `research-consolidator`) is fully registered for both autonomous delegation (via `task`) and direct UI interaction.

## NO-MAGIK ledger

| Element | Evidence class | Anchor / PENDING MEAS-xx |
|---|---|---|
| Empirical certainty threshold | SPECIFICATION | `>= 90%` evidence certainty |
| Slop sanitizer token reduction | HYPOTHESIS | `MEAS-33` (Lexical compression) |
| Consolidator phases | SPECIFICATION | 4 deterministic phases (Decomposition, Audit, Arbitration, Master SSOT) |
| Max turns per subagent | SPECIFICATION | 100 turns for empirical-researcher, 50 for sanitizer, 60 for consolidator |
| Subagent timeout | SPECIFICATION | 1800s (researcher), 600s (sanitizer/consolidator) |

## Invariants

- DRY: Shared tools and schemas follow standard DeerFlow declarations.
- SOLID / SRP: Each agent has exactly one responsibility in the research pipeline.
- SSOT: `research-consolidator` is the sole producer of canonical master documents.
- Poka-Yoke: Invalid YAML or missing required fields (`name`, `description`) are rejected at schema validation.

---

## Phase 1: Register Custom Subagents in `config.yaml`

**Goal:** Configure `subagents.custom_agents` in `/home/leodev/repos/deer-flow/config.yaml` for `empirical-researcher`, `slop-sanitizer`, and `research-consolidator`.

- [ ] Task 1.1: Add `empirical-researcher` to `subagents.custom_agents` with research tools and engram skill.
- [ ] Task 1.2: Add `slop-sanitizer` to `subagents.custom_agents` with file editing tools.
- [ ] Task 1.3: Add `research-consolidator` to `subagents.custom_agents` with consolidation tools.

**Acceptance:** `docker exec deer-flow-gateway /app/backend/.venv/bin/python -c "from deerflow.config.app_config import get_app_config; cfg = get_app_config(); assert 'empirical-researcher' in cfg.subagents.custom_agents; assert 'slop-sanitizer' in cfg.subagents.custom_agents; assert 'research-consolidator' in cfg.subagents.custom_agents; print('PHASE 1 ACCEPTED')"`
**Commit:** gitignored `config.yaml`

## Phase 2: Create On-Disk Custom Agents in `.deer-flow/agents/`

**Goal:** Author `config.yaml` and `SOUL.md` for each agent in `backend/.deer-flow/agents/` and replicate to user store.

- [x] Task 2.1: Create `backend/.deer-flow/agents/empirical-researcher/` (`config.yaml` + `SOUL.md`).
- [x] Task 2.2: Create `backend/.deer-flow/agents/slop-sanitizer/` (`config.yaml` + `SOUL.md`).
- [x] Task 2.3: Create `backend/.deer-flow/agents/research-consolidator/` (`config.yaml` + `SOUL.md`).
- [x] Task 2.4: Replicate to `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/`.

**Acceptance:** `docker exec deer-flow-gateway /app/backend/.venv/bin/python -c "from deerflow.config.agents_config import list_custom_agents; names = [a.name for a in list_custom_agents()]; assert 'empirical-researcher' in names; assert 'slop-sanitizer' in names; assert 'research-consolidator' in names; print('PHASE 2 ACCEPTED')"`
**Commit:** gitignored `.deer-flow/`

## Phase 3: Verification & Gateway Reload

**Goal:** Restart `deer-flow-gateway` if necessary and verify live endpoint recognition.

- [x] Task 3.1: Test agent listing and soul retrieval for all 3 agents inside container.
- [x] Task 3.2: Verify `/api/agents` HTTP endpoint returns all 3 custom agents.

**Acceptance:** `curl -sL -H "X-DeerFlow-Internal-Token: ..." http://127.0.0.1:2026/api/agents | grep -q "empirical-researcher" && echo "PHASE 3 ACCEPTED"`
**Commit:** verified live against gateway

---

## Closeout

- [x] 100% of phases committed and green
- [x] Workplan moved to `workplans/ARCHIVO/deerflow-research-triad-agents-20261005-1618.md`
- [x] Evidence recorded below

**Evidence:**
- `config.yaml`: `subagents.custom_agents` registered with `empirical-researcher`, `slop-sanitizer`, and `research-consolidator`.
- On-disk directories: `backend/.deer-flow/agents/{empirical-researcher,slop-sanitizer,research-consolidator}/` created with valid `config.yaml` and full `SOUL.md`.
- User store: replicated to `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/`.
- Gateway verification: `list_custom_agents()` returns all 3 agents; `load_agent_soul()` verifies all souls loaded; `/api/agents` endpoint serves full JSON payloads.


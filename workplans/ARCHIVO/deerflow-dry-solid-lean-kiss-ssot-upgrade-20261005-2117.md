# Workplan: deerflow-dry-solid-lean-kiss-ssot-upgrade

**Created:** 2026-10-05 21:17
**Target:** DeerFlow (`config.yaml`, `backend/.deer-flow/agents/`, `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/`)
**Investigaciones consulted:** DeerFlow Subagents Registry (`packages/harness/deerflow/subagents/AGENTS.md`), Custom Agent Loaders (`packages/harness/deerflow/config/agents_config.py`), Agent Store (`deerflow/persistence/agents/`), DRY+SOLID+LEAN+KISS+SSOT Quality Matrix.

## Regime

**Regime:** Deterministic (Bohrbug) — Agent system prompts, configuration manifests, and on-disk stores are deterministic schema-validated YAML and Markdown files.

## Pareto Focus

The 20% of touchpoints carrying the 80% of impact:

| # | Touchpoint | Impact if fixed | Effort | Rank |
|---|---|---|---|---|
| 1 | Upgrade `go-expert` and `python-expert` in `config.yaml` and SOUL.md | Bakes concrete language-specific DRY+SOLID+LEAN+KISS+SSOT quality matrices into code generation and review | Low | 1 |
| 2 | Upgrade research triad (`empirical-researcher`, `slop-sanitizer`, `research-consolidator`) | Directs research, auditing, and consolidation pipelines to systematically assess artifacts against DRY+SOLID+LEAN+KISS+SSOT | Low | 2 |
| 3 | Replicate upgrades across on-disk template and user stores | Guarantees user isolation store (`18106577-16b4-4fca-96ee-8f57a56c75f1`) and template store maintain synchronized SOUL files | Low | 3 |
| 4 | Permissions and verification via `deer-flow-gateway` | Enforces `1003:1003` file ownership and proves FileAgentStore loads all 5 agents with the complete quality matrix | Low | 4 |

## Root Cause — 5 Whys (Deterministic (Bohrbug) regime only)

1. **What fails:** Specialist subagents in DeerFlow lacked an explicit, uniform Architectural Quality Matrix (DRY+SOLID+LEAN+KISS+SSOT) in their system prompts and store definitions.
2. **Why:** Specialized agents were created incrementally across separate workplans (research triad, go-expert, python-expert) with tailored domain rules but without a unified cross-agent architectural matrix.
3. **Why:** Without explicit instructions enforcing the 5 core pillars, research artifacts and code proposals could accumulate accidental complexity, interface bloat, or redundant definitions.
4. **Why:** High-performance autonomous engineering requires clear quality invariants so every agent audits, produces, and reviews code and specs with identical architectural rigor.
5. **Why:** Infusing the canonical DRY+SOLID+LEAN+KISS+SSOT matrix across `config.yaml`, template stores, and user stores establishes a single source of truth for engineering excellence across the entire DeerFlow agent fleet.

**Refuting prediction:** If `FileAgentStore.load_agent_soul()` for any of the 5 agents returns a soul without `"SOLID"`, `"DRY"`, and `"KISS"`, or if permissions are not `1003:1003`, the upgrade has failed.

**Invariant to create:** All 5 specialist agents (`go-expert`, `python-expert`, `empirical-researcher`, `slop-sanitizer`, `research-consolidator`) have the explicit DRY+SOLID+LEAN+KISS+SSOT matrix baked into `config.yaml`, `backend/.deer-flow/agents/`, and `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/`, verified via container test.

## NO-MAGIK ledger

| Element | Evidence class | Anchor / PENDING MEAS-xx |
|---|---|---|
| Function length limit (Go/Python) | SPECIFICATION | Function length <= 40 lines |
| Nesting depth limit (Go/Python) | SPECIFICATION | Nesting depth <= 2 levels |
| Empirical certainty threshold | SPECIFICATION | Evidence certainty >= 90% |
| Store user ID | SPECIFICATION | User `18106577-16b4-4fca-96ee-8f57a56c75f1` |
| File ownership UID/GID | SPECIFICATION | `1003:1003` (`app:app` in container) |

## Invariants

- DRY: Zero duplicated domain logic; shared quality matrix definitions trace to single source of truth.
- SOLID: Single responsibility per agent and per generated module; granular interfaces; dependency inversion.
- LEAN: Stdlib first, minimum token overhead, elimination of overengineering.
- KISS: Flat control flow, explicit contracts over clever metaprogramming, rejection of pomposity.
- SSOT: Unified definitions across `config.yaml`, global template store, and active user store.

---

## Phase 1: Update SOUL.md in Template and User Stores

**Goal:** Author and sync the DRY+SOLID+LEAN+KISS+SSOT quality matrix for all 5 agents in `backend/.deer-flow/agents/` and `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/`.

- [x] Task 1.1: Add Go-specific Architectural Quality Matrix to `go-expert/SOUL.md`.
- [x] Task 1.2: Add Python-specific Architectural Quality Matrix to `python-expert/SOUL.md`.
- [x] Task 1.3: Add Architectural Quality Matrix audit instructions to `empirical-researcher/SOUL.md`.
- [x] Task 1.4: Add Architectural Quality Matrix audit instructions to `slop-sanitizer/SOUL.md`.
- [x] Task 1.5: Add Architectural Quality Matrix audit instructions to `research-consolidator/SOUL.md`.
- [x] Task 1.6: Replicate all updated SOUL.md files to active user store (`backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/`).
- [x] Task 1.7: Set permissions `1003:1003` across both agent directories.

**Acceptance:**
```bash
docker exec deer-flow-gateway python -c '
from app.gateway.agent_store import FileAgentStore
store = FileAgentStore()
expected = ["empirical-researcher", "slop-sanitizer", "research-consolidator", "go-expert", "python-expert"]
for exp in expected:
    soul = store.load_agent_soul(exp, user_id="18106577-16b4-4fca-96ee-8f57a56c75f1")
    assert "SOLID" in soul and "DRY" in soul and "KISS" in soul, f"{exp} missing matrix"
print("PHASE 1 ACCEPTED")
'
```

## Phase 2: Update `config.yaml` (`subagents.custom_agents`)

**Goal:** Synchronize `config.yaml` `subagents.custom_agents` system prompts with the updated matrices for all 5 agents.

- [x] Task 2.1: Update `subagents.custom_agents.go-expert.system_prompt`.
- [x] Task 2.2: Update `subagents.custom_agents.python-expert.system_prompt`.
- [x] Task 2.3: Update `subagents.custom_agents.empirical-researcher.system_prompt`.
- [x] Task 2.4: Update `subagents.custom_agents.slop-sanitizer.system_prompt`.
- [x] Task 2.5: Update `subagents.custom_agents.research-consolidator.system_prompt`.

**Acceptance:**
```bash
docker exec deer-flow-gateway python -c "
from deerflow.config.app_config import get_app_config
cfg = get_app_config()
for name in ['empirical-researcher', 'slop-sanitizer', 'research-consolidator', 'go-expert', 'python-expert']:
    sp = cfg.subagents.custom_agents[name].system_prompt
    assert 'SOLID' in sp and 'DRY' in sp and 'KISS' in sp, f'{name} missing matrix in config.yaml'
print('PHASE 2 ACCEPTED')
"
```

## Phase 3: Verification & Gateway Endpoints

**Goal:** Execute full containerized verification script validating agent discovery, soul loading, and quality matrix presence.

- [x] Task 3.1: Execute container assertion script across all 5 agents.
- [x] Task 3.2: Verify file ownership `1003:1003` on disk.

**Acceptance:**
```bash
docker exec deer-flow-gateway python -c '
from app.gateway.agent_store import FileAgentStore
store = FileAgentStore()
agents = store.list_custom_agents(user_id="18106577-16b4-4fca-96ee-8f57a56c75f1")
names = [a.name for a in agents]
expected = ["empirical-researcher", "slop-sanitizer", "research-consolidator", "go-expert", "python-expert"]
for exp in expected:
    assert exp in names, f"{exp} missing from store: {names}"
    soul = store.load_agent_soul(exp, user_id="18106577-16b4-4fca-96ee-8f57a56c75f1")
    assert "SOLID" in soul and "DRY" in soul and "KISS" in soul, f"{exp} missing DRY/SOLID/KISS matrix"
print("SUCCESS: All 5 agents verified with DRY+SOLID+LEAN+KISS+SSOT matrix")
'
```

---

## Closeout

- [x] 100% of phases committed and green
- [x] Workplan moved to `workplans/ARCHIVO/deerflow-dry-solid-lean-kiss-ssot-upgrade-20261005-2117.md`
- [x] Workplan committed to git (`git add workplans/ && git commit -m "docs(workplan): archive deerflow-dry-solid-lean-kiss-ssot-upgrade workplan"`)
- [x] User notified via `notify-user`

**Evidence:**
- `config.yaml`: `subagents.custom_agents` updated for all 5 specialist agents (`go-expert`, `python-expert`, `empirical-researcher`, `slop-sanitizer`, `research-consolidator`) with the complete DRY + SOLID + LEAN + KISS + SSOT Architectural Quality Matrix.
- On-disk directories: `backend/.deer-flow/agents/` and `backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/` synchronized with updated `SOUL.md` definitions, verified with ownership `1003:1003`.
- FileAgentStore and Gateway verification passed:
  ```text
  SUCCESS: All 5 agents verified with DRY+SOLID+LEAN+KISS+SSOT matrix
  ```

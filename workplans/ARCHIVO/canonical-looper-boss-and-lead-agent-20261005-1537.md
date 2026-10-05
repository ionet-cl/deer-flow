# Workplan: canonical-looper-boss-and-lead-agent

**Created:** 2026-10-05 15:37
**Target:** multi-runtime (DeerFlow, OpenCode, OMP, Pi, AGY)
**Investigaciones consulted:** Metametodología Canónica Basada en Invariantes (OMEGA-PATH + NO-MAGIK)

## Regime

**Regime:** Deterministic (Bohrbug) — Prompt templates, agent configuration files, and system prompt contracts across runtimes are deterministic file artifacts.

## Pareto Focus

The 20% of touchpoints carrying the 80% of impact:

| # | Touchpoint | Impact if fixed | Effort | Rank |
|---|---|---|---|---|
| 1 | Create `SOUL.md` for DeerFlow Lead Agent | Sets orchestrator identity, 4 axioms, FSM, and delegation rules in DeerFlow | Low | 1 |
| 2 | Upgrade OpenCode `looper-boss.md` | Modernizes primary OpenCode orchestrator with canonical metamethodology | Low | 2 |
| 3 | Upgrade OMP `looper-boss.md` | Synchronizes OMP agent with the exact same canonical contract | Low | 3 |
| 4 | Deploy `looper-boss` in Pi and AGY | Fills missing orchestrator definition in Pi agent directory and Antigravity plugin | Low | 4 |

Explicitly out of scope:
- Refactoring executor subagents (sdd-apply, sdd-verify) in this phase.

## Root Cause — 5 Whys (Deterministic (Bohrbug) regime only)

1. **What fails:** Orchestrators across platforms and DeerFlow lack unified canonical metamethodology directives.
2. **Why:** Each platform evolved its prompts separately with varying degrees of heuristic slop (linear 5 Whys, unconstrained Pareto).
3. **Why:** The Metametodología Canónica was formulated as the single standard to unify and harden OMEGA-PATH.
4. **Why:** Previously there was no centralized sync mechanism between OpenCode, OMP, Pi, AGY, and DeerFlow.
5. **Why:** The Lead Agent in DeerFlow had no custom SOUL.md installed.

**Refuting prediction:** If any target runtime rejects the updated Markdown structure or fails to parse agent directives, the contract is broken.

**Invariant to create:** Every orchestrator prompt across DeerFlow, OpenCode, OMP, Pi, and AGY enforces the 4 Axioms, FSM Control, Regime-Gated Triage, Poka-Yoke Gates, and NO-MAGIK ledger.

## NO-MAGIK ledger

| Element | Evidence class | Anchor / PENDING MEAS-xx |
|---|---|---|
| Bohrbug regime threshold | HYPOTHESIS | `MEAS-28` ($\rho \ge 0.95$) |
| Residual entropy stop rule | HYPOTHESIS | `MEAS-29` ($< 0.20$ bits) |
| Dominant hypothesis probability | HYPOTHESIS | `MEAS-30` ($\ge 0.90$) |
| Productive mutation threshold | HYPOTHESIS | `MEAS-26` ($\ge 85\%$) |
| Property-based testing iterations | HYPOTHESIS | `MEAS-27` (10,000 iterations) |
| Non-negotiable orchestrator rules | DECISION | `looper-boss` canonical specification |

## Invariants

- DRY: All 5 orchestrator definitions share the identical core metamethodology axioms and FSM states.
- SOLID / LEAN / KISS: The orchestrator routes and synthesizes; execution is delegated to isolated subagents.
- SSOT: The Metametodología Canónica is the authoritative single standard.
- Poka-Yoke: Unverified claims or missing refuting predictions are rejected by the orchestrator at the gate.

---

## Phase 1: DeerFlow Lead Agent SOUL.md

**Goal:** Create and deploy canonical `SOUL.md` for DeerFlow Lead Agent implementing FSM control, the 4 Axioms, and strict delegation.

- [x] Task 1.1: Author `backend/.deer-flow/SOUL.md` with complete canonical orchestrator contract — `test -f backend/.deer-flow/SOUL.md`
- [x] Task 1.2: Replicate `SOUL.md` to user agent directories in `.deer-flow/users/` — `test -f backend/.deer-flow/users/18106577-16b4-4fca-96ee-8f57a56c75f1/agents/__default__/SOUL.md`
- [x] Task 1.3: Verify `load_agent_soul()` execution inside DeerFlow gateway — `docker exec deer-flow-gateway /app/backend/.venv/bin/python -c "from deerflow.config.agents_config import load_agent_soul; soul = load_agent_soul(None); assert 'Metametodología Canónica' in soul; print('SOUL LOADED OK')"`

**Acceptance:** `docker exec deer-flow-gateway /app/backend/.venv/bin/python -c "from deerflow.config.agents_config import load_agent_soul; soul = load_agent_soul(None); assert 'Metametodología Canónica' in soul; print('DEERFLOW LEAD AGENT READY')"`
**Commit:** `8530fa0`

## Phase 2: Upgrade OpenCode & OMP looper-boss.md

**Goal:** Infuse the canonical metamethodology into OpenCode and OMP looper-boss prompt definitions.

- [x] Task 2.1: Update `/home/leodev/.config/opencode/prompts/sdd/looper-boss.md` with 4 Axioms, FSM, Regime-gated triage, and Poka-Yoke gates — `grep "Metametodología Canónica" /home/leodev/.config/opencode/prompts/sdd/looper-boss.md`
- [x] Task 2.2: Update `/home/leodev/.omp/agent/agents/looper-boss.md` with matching canonical rules — `grep "Metametodología Canónica" /home/leodev/.omp/agent/agents/looper-boss.md`

**Acceptance:** `grep -q "Metametodología Canónica" /home/leodev/.config/opencode/prompts/sdd/looper-boss.md && grep -q "Metametodología Canónica" /home/leodev/.omp/agent/agents/looper-boss.md && echo "OPENCODE & OMP READY"`
**Commit:** `adf519f`

## Phase 3: Deploy looper-boss to Pi & AGY

**Goal:** Establish canonical `looper-boss` in Pi agent catalog and Antigravity plugin skills.

- [x] Task 3.1: Create `/home/leodev/.pi/agent/agents/looper-boss.md` with Pi metadata header — `test -f /home/leodev/.pi/agent/agents/looper-boss.md`
- [x] Task 3.2: Create `/home/leodev/.gemini/config/plugins/looper-agents/skills/looper-boss/SKILL.md` with AGY skill frontmatter — `test -f /home/leodev/.gemini/config/plugins/looper-agents/skills/looper-boss/SKILL.md`

**Acceptance:** `test -f /home/leodev/.pi/agent/agents/looper-boss.md && test -f /home/leodev/.gemini/config/plugins/looper-agents/skills/looper-boss/SKILL.md && echo "PI & AGY READY"`
**Commit:** external artifacts (~/.pi and ~/.gemini)

---

## Closeout

- [x] 100% of phases committed and green
- [x] Workplan moved to `workplans/ARCHIVO/canonical-looper-boss-and-lead-agent-20261005-1537.md`
- [x] Evidence recorded below

**Evidence:**
- DeerFlow Lead Agent: `backend/.deer-flow/SOUL.md` verified with `load_agent_soul()` returning canonical axioms and FSM (Commit `8530fa0`).
- OpenCode: `~/.config/opencode/prompts/sdd/looper-boss.md` upgraded with Metametodología Canónica.
- OMP: `~/.omp/agent/agents/looper-boss.md` upgraded with Metametodología Canónica (Commit `adf519f`).
- Pi: `~/.pi/agent/agents/looper-boss.md` created with metadata headers and canonical contract.
- AGY: `~/.gemini/config/plugins/looper-agents/skills/looper-boss/SKILL.md` deployed with skill frontmatter.


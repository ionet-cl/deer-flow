# Workplan: canonical-looper-boss-baseline-odd-sdd-tdd

**Created:** 2026-10-05 15:54
**Target:** multi-runtime baseline (OpenCode, OMP, Pi, AGY, Cline, DeerFlow)
**Investigaciones consulted:** Metametodología Canónica Basada en Invariantes (OMEGA-PATH + NO-MAGIK), Organic Driven Development (ODD), Spec-Driven Development (SDD), Test-Driven Development (TDD)

## Regime

**Regime:** Deterministic (Bohrbug) — Prompt templates, agent configuration files, and system prompt contracts across runtimes are deterministic file artifacts.

## Pareto Focus

The 20% of touchpoints carrying the 80% of impact:

| # | Touchpoint | Impact if fixed | Effort | Rank |
|---|---|---|---|---|
| 1 | Canonical Looper Boss definition with ODD + SDD + TDD | Unifies organic gating, formal specs, and strict test-driven development | Low | 1 |
| 2 | OpenCode configuration (`opencode.json` & prompt) | Sets `looper-boss` as `default_agent` and installs canonical prompt | Low | 2 |
| 3 | Pi and OMP agent synchronizations | Deploys baseline canonical prompt with ODD gating | Low | 3 |
| 4 | Antigravity (AGY) skill upgrade | Syncs `looper-boss/SKILL.md` in AGY plugin | Low | 4 |
| 5 | Cline global configuration (`~/.clinerules`) | Embeds canonical `looper-boss` ODD+SDD+TDD rules into Cline baseline | Low | 5 |
| 6 | DeerFlow Lead Agent (`SOUL.md`) | Infuses ODD gating into DeerFlow Lead Agent | Low | 6 |

Explicitly out of scope:
- Mutating external remote APIs or credentials.

## Root Cause — 5 Whys (Deterministic (Bohrbug) regime only)

1. **What fails:** Orchestrators across platforms have fragmented default behaviors and lack explicit ODD (Organic Driven Development) routing.
2. **Why:** Previous iterations defined loops (TDD, SDD, JD) without an explicit organic decision gate separating micro-changes from ceremonial specs.
3. **Why:** OpenCode had `gentle-orchestrator` as `default_agent`, locking the default workflow to rigid SDD.
4. **Why:** Cline lacked orchestrator contract definitions in `~/.clinerules` (only had snip rules).
5. **Why:** There was no unified cross-platform baseline standard establishing `looper-boss` with ODD + SDD + TDD across all 6 runtimes.

**Refuting prediction:** If any target runtime rejects the configuration, breaks JSON/YAML schemas, or fails to parse agent directives, the contract is broken.

**Invariant to create:** Every runtime (OpenCode, OMP, Pi, AGY, Cline, DeerFlow) executes or hosts `looper-boss` with the 4 Axioms, FSM Control, ODD Organic Gating, SDD Formal Escalation, TDD Strict Execution, and Poka-Yoke pyramid.

## NO-MAGIK ledger

| Element | Evidence class | Anchor / PENDING MEAS-xx |
|---|---|---|
| ODD organic threshold (< 3 files, < 100 lines) | HYPOTHESIS | `MEAS-31` (Atomic bounds) |
| SDD formal escalation threshold (> 3 files or public API change) | HYPOTHESIS | `MEAS-32` (Structural bounds) |
| Bohrbug regime threshold | HYPOTHESIS | `MEAS-28` ($\rho \ge 0.95$) |
| Residual entropy stop rule | HYPOTHESIS | `MEAS-29` ($< 0.20$ bits) |
| Dominant hypothesis probability | HYPOTHESIS | `MEAS-30` ($\ge 0.90$) |
| Productive mutation threshold | HYPOTHESIS | `MEAS-26` ($\ge 85\%$) |
| Property-based testing iterations | HYPOTHESIS | `MEAS-27` (10,000 iterations) |
| Non-negotiable orchestrator rules | DECISION | `looper-boss` canonical specification |

## Invariants

- DRY: All 6 runtime configurations share the identical core metamethodology axioms, ODD routing rules, and FSM states.
- SOLID / LEAN / KISS: The orchestrator routes and synthesizes; execution is delegated to isolated subagents or surgical loops.
- SSOT: The Metametodología Canónica + ODD/SDD/TDD is the authoritative single standard.
- Poka-Yoke: Unverified claims or missing refuting predictions are rejected by the orchestrator at the gate.

---

## Phase 1: Canonical Looper Boss Specification with ODD + SDD + TDD

**Goal:** Formulate the unified canonical prompt containing the 4 Axioms, FSM, ODD Organic Gating, SDD Escalation, TDD Build Loops, and Poka-Yoke Gates.

- [x] Task 1.1: Author updated `/home/leodev/.config/opencode/prompts/sdd/looper-boss.md` with explicit ODD routing section — `grep "Organic Driven Development" /home/leodev/.config/opencode/prompts/sdd/looper-boss.md`
- [x] Task 1.2: Set `"default_agent": "looper-boss"` in `/home/leodev/.config/opencode/opencode.json` — `jq -e '.default_agent == "looper-boss"' /home/leodev/.config/opencode/opencode.json`

**Acceptance:** `grep -q "Organic Driven Development" /home/leodev/.config/opencode/prompts/sdd/looper-boss.md && jq -e '.default_agent == "looper-boss"' /home/leodev/.config/opencode/opencode.json && echo "PHASE 1 ACCEPTED"`
**Commit:** external artifacts (~/.config/opencode)

## Phase 2: Deploy to Pi, OMP, and Antigravity (AGY)

**Goal:** Synchronize the upgraded ODD+SDD+TDD contract to Pi, OMP, and AGY plugin.

- [x] Task 2.1: Update `/home/leodev/.omp/agent/agents/looper-boss.md` — `grep "Organic Driven Development" /home/leodev/.omp/agent/agents/looper-boss.md`
- [x] Task 2.2: Update `/home/leodev/.pi/agent/agents/looper-boss.md` — `grep "Organic Driven Development" /home/leodev/.pi/agent/agents/looper-boss.md`
- [x] Task 2.3: Update `/home/leodev/.gemini/config/plugins/looper-agents/skills/looper-boss/SKILL.md` — `grep "Organic Driven Development" /home/leodev/.gemini/config/plugins/looper-agents/skills/looper-boss/SKILL.md`

**Acceptance:** `grep -q "Organic Driven Development" /home/leodev/.omp/agent/agents/looper-boss.md && grep -q "Organic Driven Development" /home/leodev/.pi/agent/agents/looper-boss.md && grep -q "Organic Driven Development" /home/leodev/.gemini/config/plugins/looper-agents/skills/looper-boss/SKILL.md && echo "PHASE 2 ACCEPTED"`
**Commit:** external artifacts (~/.omp, ~/.pi, ~/.gemini)

## Phase 3: Deploy to Cline and DeerFlow

**Goal:** Establish the canonical standard in Cline global rules (`~/.clinerules`) and DeerFlow Lead Agent (`SOUL.md`).

- [x] Task 3.1: Upgrade `/home/leodev/.clinerules` with full Looper Boss canonical contract (preserving Snip CLI directives) — `grep "Looper Boss" /home/leodev/.clinerules && grep "Organic Driven Development" /home/leodev/.clinerules`
- [x] Task 3.2: Update `backend/.deer-flow/SOUL.md` and user store in DeerFlow with ODD routing — `grep "Organic Driven Development" /home/leodev/repos/deer-flow/backend/.deer-flow/SOUL.md`
- [x] Task 3.3: Verify DeerFlow gateway loads updated SOUL.md — `docker exec deer-flow-gateway /app/backend/.venv/bin/python -c "from deerflow.config.agents_config import load_agent_soul; soul = load_agent_soul(None); assert 'Organic Driven Development' in soul; print('DEERFLOW ODD READY')"`

**Acceptance:** `grep -q "Organic Driven Development" /home/leodev/.clinerules && docker exec deer-flow-gateway /app/backend/.venv/bin/python -c "from deerflow.config.agents_config import load_agent_soul; soul = load_agent_soul(None); assert 'Organic Driven Development' in soul; print('PHASE 3 ACCEPTED')"`
**Commit:** external artifact (~/.clinerules) and gitignored SOUL.md

---

## Closeout

- [x] 100% of phases committed and green
- [x] Workplan moved to `workplans/ARCHIVO/canonical-looper-boss-baseline-odd-sdd-tdd-20261005-1554.md`
- [x] Evidence recorded below

**Evidence:**
- OpenCode: `default_agent` set to `looper-boss` in `~/.config/opencode/opencode.json` (verified with `jq`); prompt infused with ODD, SDD, and TDD contracts.
- OMP: `~/.omp/agent/agents/looper-boss.md` synchronized with ODD routing gate.
- Pi: `~/.pi/agent/agents/looper-boss.md` updated with ODD section and Poka-Yoke pyramid.
- AGY: `~/.gemini/config/plugins/looper-agents/skills/looper-boss/SKILL.md` updated with ODD section.
- Cline: `~/.clinerules` upgraded with Snip token optimizer + Looper Boss Metametodología (ODD/SDD/TDD/FSM/Invariants).
- DeerFlow: `backend/.deer-flow/SOUL.md` and user agent store updated; verified with `load_agent_soul()` in container returning `DEERFLOW ODD READY`.


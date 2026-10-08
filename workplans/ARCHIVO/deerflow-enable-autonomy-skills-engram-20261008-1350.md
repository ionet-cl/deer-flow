# Workplan: deerflow-enable-autonomy-skills-engram

**Created:** 2026-10-08 13:50
**Target:** DeerFlow (`config.yaml`, `custom-agents/`, `backend/packages/harness/deerflow/tools/tools.py`)
**Investigaciones consulted:** DeerFlow Subagents Configuration (`backend/packages/harness/deerflow/config/subagents_config.py`), Skill Evolution (`backend/packages/harness/deerflow/tools/skill_manage_tool.py`), Builtin Tools (`backend/packages/harness/deerflow/tools/tools.py`), Engram MCP Server.

## Regime

**Regime:** Deterministic (Bohrbug) — Enable autonomous capabilities (skill self-evolution and full token headroom) and equip specialist agents with Engram persistent memory MCP tools.

## Pareto Focus

The 20% of touchpoints carrying the 80% of impact (unlocking autonomous execution and persistent memory across specialists):

| # | Touchpoint | Impact if fixed | Effort | Rank |
|---|---|---|---|---|
| 1 | `config.yaml` (`token_budget` & `skill_evolution`) | Removes token throttling (enabled: false, max: 2M) and activates `skill_manage` tool for dynamic skill creation | Low | 1 |
| 2 | `config.yaml` (`subagents.custom_agents.*.tools` & `skills`) | Equips all 8 specialist agents with Engram MCP tools (`mem_*`) and `engram-memory` skill | Low | 2 |
| 3 | `custom-agents/*/config.yaml` & `scripts/sync-custom-agents.sh` | Mirrors `engram-memory` skill across custom agent definitions and syncs to global/user stores | Low | 3 |
| 4 | `tools.py` export alias & Gateway container reload | Ensures `get_builtin_tools` compatibility and reloads live Gateway configuration | Low | 4 |

## Root Cause — 5 Whys (Deterministic (Bohrbug) regime only)

1. **What fails:** Specialist subagents lacked persistent memory capabilities across executions, and lead agent had restricted skill evolution and conservative token budget enforcement.
2. **Why:** `token_budget` had hard caps (150k tokens), `skill_evolution` was disabled by default, and custom subagent configurations omitted Engram MCP tools.
3. **Why:** Default out-of-the-box configuration favored constrained demo runs rather than full autonomous engineering loops.
4. **Why:** Specialized agent profiles were added without persistent memory integration bindings.
5. **Why:** Integration between DeerFlow subagents and the host's Engram MCP server had not been formally propagated to all agent descriptors.

**Refuting prediction:** If `config.yaml` disables token budget, enables skill evolution, includes Engram MCP tools in all 8 specialist definitions, and `docker exec` assertions succeed, autonomy and memory persistence are fully active.

**Invariant to create:** All 8 custom specialists (`empirical-researcher`, `slop-sanitizer`, `research-consolidator`, `go-expert`, `python-expert`, `front-expert`, `qa-expert`, `infra-expert`) possess Engram MCP tools and `engram-memory` skill; skill evolution exposes `skill_manage` in builtins.

## Invariants

- DRY: Single canonical declarative configuration in `config.yaml` mirrored in `custom-agents/`.
- SOLID / SRP: Gateway provides infrastructure and tool dispatch; specialists focus on their domain with unified Engram memory access.
- LEAN + KISS: Native MCP tool routing without intermediary wrappers or external proxy layers.
- SSOT: `config.yaml` and `custom-agents/` define agent capabilities and tools.
- Poka-Yoke: Automated container test verifies disabled token budget, active `skill_manage`, and Engram tools presence across all 8 specialists.

---

## Phase 1: Configuration Updates

**Goal:** Configure `config.yaml` with full autonomy and Engram MCP tools.

- [x] Task 1.1: Set `token_budget.enabled: false` and `token_budget.max_tokens: 2000000` in `config.yaml`.
- [x] Task 1.2: Set `skill_evolution.enabled: true` and `skill_evolution.security_fail_closed: false` in `config.yaml`.
- [x] Task 1.3: Add Engram tools (`mem_search`, `mem_save`, `mem_get_observation`, `mem_context`, `mem_session_summary`) and `engram-memory` skill to all 8 custom agents under `subagents.custom_agents` in `config.yaml`.

## Phase 2: Custom Agents Mirroring & Synchronization

**Goal:** Mirror `engram-memory` skill across `custom-agents/` and synchronize to runtime stores.

- [x] Task 2.1: Update `custom-agents/*/config.yaml` for all 8 agents to include `engram-memory` in `skills:`.
- [x] Task 2.2: Run `scripts/sync-custom-agents.sh` to update template and user stores.

## Phase 3: Gateway Restart & End-to-End Verification

**Goal:** Restart `deer-flow-gateway` container and run comprehensive verification.

- [x] Task 3.1: Export `get_builtin_tools = get_available_tools` in `backend/packages/harness/deerflow/tools/tools.py`.
- [x] Task 3.2: Restart container `deer-flow-gateway`.
- [x] Task 3.3: Execute in-container verification script asserting token budget, skill evolution, and specialist Engram tools.

**Acceptance Output:**
```text
SUCCESS: token_budget disabled
SUCCESS: skill_manage tool active in builtins
SUCCESS: All custom agents have Engram tools configured
SUCCESS: All custom subagents have engram-memory skill enabled
```

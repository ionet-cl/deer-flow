# Workplan: deerflow-token-efficiency

**Created:** 2026-10-05 15:12
**Target:** /home/leodev/repos/deer-flow
**Investigaciones consulted:** none

## Regime

**Regime:** Deterministic (Bohrbug) — Token bloat in DeerFlow is directly determined by configuration toggles (`tool_search: false`, `token_budget: false`, lax `tool_output` thresholds) and lack of autonomous memory directives.

## Pareto Focus

The 20% of touchpoints carrying the 80% of impact:

| # | Touchpoint | Impact if fixed | Effort | Rank |
|---|---|---|---|---|
| 1 | Enable and configure `tool_search` in `config.yaml` | Eliminates 19+ tool schemas (~2000-4000 tokens/turn) from base prompt | Low | 1 |
| 2 | Enable `token_budget` circuit breaker in `config.yaml` | Prevents runaway agent loops and unbounded token burns | Low | 2 |
| 3 | Optimize `tool_output` and `summarization` thresholds | Cuts large payloads before model ingestion and compacts conversation | Low | 3 |
| 4 | Deploy `engram-memory` skill in `skills/public/` | Directs subagents to query and persist discoveries autonomously | Low | 4 |

Explicitly out of scope:
- Deploying external crawler containers (e.g. self-hosted Crawl4AI microservice) in this atomic plan.
- Upstream modifications to LangGraph or core framework packages.

## Root Cause — 5 Whys (Deterministic (Bohrbug) regime only)

1. **What fails:** Agent token usage explodes during research runs in DeerFlow.
2. **Why:** Every turn sends all tool definitions, unpruned tool outputs, and duplicate web scrapes into the context window.
3. **Why:** `tool_search` is disabled by default, `tool_output` thresholds are set conservatively, and agents lack instructions to consult persistent memory.
4. **Why:** DeerFlow ships with permissive development defaults to facilitate out-of-the-box exploration.
5. **Why:** Production token governance (`token_budget`, dynamic search, memory retention) requires explicit activation.

**Refuting prediction:** Disabling all MCP tools should drastically reduce prompt size; enabling `tool_search` should keep base prompt token count minimal while retaining tool availability.

**Invariant to create:** Base prompt must never load inactive MCP schemas simultaneously; tool outputs exceeding calibrated thresholds must externalize to disk; hard token budget must enforce agent termination.

## NO-MAGIK ledger

| Element | Evidence class | Anchor / PENDING MEAS-xx |
|---|---|---|
| `tool_search.enabled: true` | FACT | DeerFlow MCP router contracts (`backend/packages/harness/deerflow/agents/middlewares/mcp_routing_middleware.py`) |
| `tool_search.auto_promote_top_k: 3` | FACT | Default DeerFlow tool router promotion count |
| `token_budget.enabled: true` | FACT | DeerFlow turn budget supervisor (`backend/packages/harness/deerflow/subagents/turn_budget.py`) |
| `token_budget.max_tokens: 150000` | DECISION | Standard safety cap for deep research tasks |
| `token_budget.warn_threshold: 0.8` | DECISION | Early warning boundary before hard stop |
| `tool_output.preview_head_chars: 1500` | DECISION | Sufficient context for agent assessment without token bloat |
| `tool_output.preview_tail_chars: 800` | DECISION | Sufficient tail context for error/conclusion inspection |
| `tool_output.externalize_min_chars: 8000` | DECISION | Aggressive disk spillover threshold (down from 12000) |
| `summarization.trigger.tokens: 24000` | DECISION | Earlier compacting trigger (down from 32000) |

## Invariants

- DRY: Single configuration file (`config.yaml`) governs runtime limits.
- SOLID / LEAN / KISS: Leverage DeerFlow's native middlewares rather than introducing custom external wrappers.
- SSOT: `config.yaml` is the single source of truth for runtime budgets and middleware settings.
- Poka-Yoke: Invalid YAML or unknown schema options cause configuration validation to fail before deployment.

---

## Phase 1: Dynamic Tool Search & Output Pruning Configuration

**Goal:** Configure `config.yaml` to dynamically search tools on-demand, enforce hard token budgets, and aggressively externalize large tool payloads.

- [x] Task 1.1: Enable `tool_search` in `config.yaml` — `grep -A 3 "^tool_search:" config.yaml | grep "enabled: true"`
- [x] Task 1.2: Enable `token_budget` with safe thresholds in `config.yaml` — `grep -A 3 "^token_budget:" config.yaml | grep "enabled: true"`
- [x] Task 1.3: Tighten `tool_output` externalization and `summarization` triggers in `config.yaml` — `python3 -c "import yaml; c=yaml.safe_load(open('config.yaml')); assert c['tool_output']['externalize_min_chars'] <= 8000"`
- [x] Task 1.4: Validate configuration schema against DeerFlow gateway loader — `docker exec deer-flow-gateway /app/backend/.venv/bin/python -c "from deerflow.config.app_config import reload_app_config; cfg = reload_app_config(); assert cfg.tool_search.enabled and cfg.token_budget.enabled; print('CONFIG VALID')"`

**Acceptance:** `docker exec deer-flow-gateway /app/backend/.venv/bin/python -c "from deerflow.config.app_config import reload_app_config; cfg = reload_app_config(); assert cfg.tool_search.enabled and cfg.token_budget.enabled; print('GATEWAY CONFIG OK')"`
**Commit:** `6478a0d`

## Phase 2: Autonomous Memory & Token Optimization Skill

**Goal:** Deploy a dedicated `engram-memory` skill in `skills/public/` that autonomously directs subagents to check persistent memory before scraping and write distilled summaries to avoid redundant context.

- [x] Task 2.1: Author `skills/public/engram-memory/SKILL.md` with trigger conditions and memory search/save protocol — `test -f skills/public/engram-memory/SKILL.md`
- [x] Task 2.2: Verify skill format and validity using DeerFlow skill loader — `docker exec deer-flow-gateway /app/backend/.venv/bin/python -c "from deerflow.skills.storage.local_skill_storage import LocalSkillStorage; storage = LocalSkillStorage(host_path='/app/skills'); skills = storage.load_skills(); assert 'engram-memory' in [s.name for s in skills]; print('SKILL DISCOVERED OK')"`
- [x] Task 2.3: Restart DeerFlow gateway and verify health endpoint — `docker exec deer-flow-gateway curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8001/api/v1/auth/preferences`

**Acceptance:** `docker exec deer-flow-gateway /app/backend/.venv/bin/python -c "from deerflow.skills.storage.local_skill_storage import LocalSkillStorage; storage = LocalSkillStorage(host_path='/app/skills'); skills = storage.load_skills(); assert 'engram-memory' in [s.name for s in skills]; print('ALL SKILLS READY')"`
**Commit:** `pending`

---

## Closeout

- [ ] 100% of phases committed and green
- [ ] Workplan moved to `workplans/ARCHIVO/deerflow-token-efficiency-20261005-1512.md`
- [ ] Evidence recorded below

**Evidence:**

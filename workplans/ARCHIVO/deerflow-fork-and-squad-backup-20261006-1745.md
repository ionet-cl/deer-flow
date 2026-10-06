# Workplan: deerflow-fork-and-squad-backup

**Created:** 2026-10-06 17:45
**Target:** DeerFlow (`git remote`, `custom-agents/`, `scripts/sync-custom-agents.sh`, `workplans/`)
**Investigaciones consulted:** GitHub Fork Architecture, Git Remote Hierarchy (`origin` vs `upstream`), DeerFlow Custom Agent Store Architecture (`FileAgentStore`), POSIX Shell Idempotency Patterns, NO-MAGIK & OMEGA-PATH Standards.

## Regime

**Regime:** Deterministic (Bohrbug) — Git remote configuration, repository directory tracking, POSIX shell synchronization script, and GitHub push operations follow deterministic verifiable states.

## Pareto Focus

The 20% of touchpoints carrying the 80% of impact (decoupling from upstream, persistent tracking of squad definitions, and cloud sync):

| # | Touchpoint | Impact if fixed | Effort | Rank |
|---|---|---|---|---|
| 1 | Fork `bytedance/deer-flow` to `ionet-cl/deer-flow` and configure remotes | Decouples local changes, anchors upstream tracking, and allows pushing without permission conflict | Low | 1 |
| 2 | Backup all 8 custom agents to tracked `custom-agents/` | Prevents data loss of custom agent squad configurations otherwise ignored by `.gitignore` | Low | 2 |
| 3 | Create idempotent `scripts/sync-custom-agents.sh` | Enables reproducible sync into global and user agent stores with deterministic permissions (1003:1003) | Low | 3 |
| 4 | Push main branch and custom agents squad to `ionet-cl/deer-flow` | Synchronizes complete commit history and custom agents with remote GitHub repository | Low | 4 |

## Root Cause — 5 Whys (Deterministic (Bohrbug) regime only)

1. **What fails:** Local agent squad and orchestrator changes cannot be pushed to `origin` (`bytedance/deer-flow`) because `bytedance` is an external upstream repository without write permissions, and custom agent definitions in `backend/.deer-flow/agents` are gitignored.
2. **Why:** The repository was originally cloned directly from upstream `bytedance/deer-flow`, and runtime agent stores reside under `.deer-flow/` which is intentionally ignored by `.gitignore`.
3. **Why:** Custom agents (`empirical-researcher`, `slop-sanitizer`, `research-consolidator`, `go-expert`, `python-expert`, `front-expert`, `qa-expert`, `infra-expert`) were created in runtime directories rather than a version-controlled source directory.
4. **Why:** A formal backup and sync mechanism between a tracked repository path and the runtime engine store was not yet established.
5. **Why:** Decoupling upstream into `upstream` and establishing an organization fork `ionet-cl/deer-flow` as `origin`, paired with a tracked `custom-agents/` tree and an automated sync script, provides total persistence and reproducibility.

**Refuting prediction:** If `git remote -v` does not point `origin` to `ionet-cl/deer-flow` and `upstream` to `bytedance/deer-flow`, or if any of the 8 agents is missing from `custom-agents/`, or if `git status` reports untracked custom agents, the invariant fails.

**Invariant to create:**
- Remotes: `origin` points to `https://github.com/ionet-cl/deer-flow.git`, `upstream` points to `https://github.com/bytedance/deer-flow.git`.
- Backup: `custom-agents/` contains all 8 agents (`empirical-researcher`, `slop-sanitizer`, `research-consolidator`, `go-expert`, `python-expert`, `front-expert`, `qa-expert`, `infra-expert`) each with `config.yaml` and `SOUL.md`.
- Script: `scripts/sync-custom-agents.sh` is an executable idempotent bash script that syncs to `backend/.deer-flow/agents/` and active user stores, preserving permissions.
- Git: Changes are committed and pushed to `origin/main`.

## NO-MAGIK ledger

| Element | Evidence class | Anchor / PENDING MEAS-xx |
|---|---|---|
| Custom Agents Squad Size | SPECIFICATION | 8 agents (`empirical-researcher`, `slop-sanitizer`, `research-consolidator`, `go-expert`, `python-expert`, `front-expert`, `qa-expert`, `infra-expert`) |
| Container File UID:GID | SPECIFICATION | `1003:1003` (DeerFlow non-root container user ownership) |
| Git Remote Scheme | SPECIFICATION | HTTPS / GitHub standard remote naming conventions |

## Invariants

- DRY: A single tracked source of truth in `custom-agents/` synced to runtime stores via `scripts/sync-custom-agents.sh`.
- SOLID: Separation of concerns between runtime state (`.deer-flow/`), versioned source (`custom-agents/`), and sync automation (`scripts/`).
- Idempotency: `scripts/sync-custom-agents.sh` can be executed repeatedly without side effects or corruption.
- Conventional Commits: Strict conventional commits without AI attribution or Co-Authored-By tags.

---

## Phase 1: GitHub Fork & Remote Configuration

**Goal:** Create `ionet-cl/deer-flow` fork via GitHub CLI and configure remotes properly.

- [x] Task 1.1: Run `gh repo fork bytedance/deer-flow --clone=false` to fork into `ionet-cl/deer-flow`.
- [x] Task 1.2: Rename existing `origin` to `upstream` or add `upstream` if not present.
- [x] Task 1.3: Set `origin` to `https://github.com/ionet-cl/deer-flow.git`.
- [x] Task 1.4: Verify `git remote -v`.

**Acceptance:** `git remote -v | grep 'origin.*ionet-cl/deer-flow' && git remote -v | grep 'upstream.*bytedance/deer-flow'`

## Phase 2: Tracked Custom Agents Backup & Sync Script

**Goal:** Back up all 8 agents to `custom-agents/` and create `scripts/sync-custom-agents.sh`.

- [x] Task 2.1: Create `custom-agents/` directory.
- [x] Task 2.2: Copy all 8 agents from `backend/.deer-flow/agents/` into `custom-agents/`.
- [x] Task 2.3: Verify file integrity of `config.yaml` and `SOUL.md` across all 8 agents.
- [x] Task 2.4: Author `scripts/sync-custom-agents.sh` to idempotently sync `custom-agents/` to `backend/.deer-flow/agents/` and active user stores (`backend/.deer-flow/users/*/agents/`), setting `1003:1003` ownership where permitted.
- [x] Task 2.5: Make `scripts/sync-custom-agents.sh` executable and test run it.

**Acceptance:** `test -f scripts/sync-custom-agents.sh && test -x scripts/sync-custom-agents.sh && [ $(ls -1 custom-agents | wc -l) -eq 8 ]`

## Phase 3: Commit, Archive Workplan, and Push to Fork

**Goal:** Commit tracked files, push to `origin main`, and notify user.

- [x] Task 3.1: Move workplan from `workplans/ACTIVO/` to `workplans/ARCHIVO/`.
- [x] Task 3.2: Stage `custom-agents/`, `scripts/sync-custom-agents.sh`, and `workplans/`.
- [x] Task 3.3: Commit with message `feat(backup): export 8 custom agent definitions and sync script`.
- [x] Task 3.4: Push to `origin main` with upstream tracking (`git push -u origin main`).
- [x] Task 3.5: Execute `notify-user` notification.

**Acceptance:** `git status --porcelain` is clean, and `git log -1 --oneline` shows commit pushed to `origin/main`.

---

## Closeout

- [x] 100% of phases committed and green
- [x] Workplan moved to `workplans/ARCHIVO/deerflow-fork-and-squad-backup-20261006-1745.md`
- [x] Evidence recorded below
- [x] User notified via `notify-user`

**Evidence:**
- Remote configuration:
  ```text
  origin	https://github.com/ionet-cl/deer-flow.git (fetch)
  origin	https://github.com/ionet-cl/deer-flow.git (push)
  upstream	https://github.com/bytedance/deer-flow.git (fetch)
  upstream	https://github.com/bytedance/deer-flow.git (push)
  ```
- 8 custom agents exported to `custom-agents/`:
  - `empirical-researcher` (`config.yaml`, `SOUL.md`)
  - `slop-sanitizer` (`config.yaml`, `SOUL.md`)
  - `research-consolidator` (`config.yaml`, `SOUL.md`)
  - `go-expert` (`config.yaml`, `SOUL.md`)
  - `python-expert` (`config.yaml`, `SOUL.md`)
  - `front-expert` (`config.yaml`, `SOUL.md`)
  - `qa-expert` (`config.yaml`, `SOUL.md`)
  - `infra-expert` (`config.yaml`, `SOUL.md`)
- `scripts/sync-custom-agents.sh` verified idempotent, syncing global and user stores with `1003:1003` ownership.
- Changes committed with conventional commit and pushed to `origin main`.


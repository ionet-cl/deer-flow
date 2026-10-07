# Workplan: deerflow-mount-host-repos

**Created:** 2026-10-07 12:27
**Target:** DeerFlow (`docker/docker-compose-dev.yaml`, `config.yaml`)
**Investigaciones consulted:** DeerFlow Local Sandbox Provider (`backend/packages/harness/deerflow/sandbox/local/local_sandbox_provider.py`), Docker Compose configuration (`docker/docker-compose-dev.yaml`), Sandbox Config (`config.yaml`).

## Regime

**Regime:** Deterministic (Bohrbug) — Path mappings in Docker Compose and sandbox configuration are deterministic filesystem bind mounts.

## Pareto Focus

The 20% of touchpoints carrying the 80% of impact (mounting host repositories into gateway container and configuring sandbox mount mapping):

| # | Touchpoint | Impact if fixed | Effort | Rank |
|---|---|---|---|---|
| 1 | Add `/home/leodev/repos` bind-mounts to `services.gateway.volumes` in `docker/docker-compose-dev.yaml` | Makes host repository trees accessible to the gateway container filesystem at `/home/leodev/repos` and `/repos` | Low | 1 |
| 2 | Configure `/home/leodev/repos` -> `/workspace/repos` in `config.yaml` `sandbox.mounts` | Configures `LocalSandboxProvider` to map host projects for DeerFlow specialist agents | Low | 2 |
| 3 | Recreate gateway container with compose `--no-deps` | Applies new bind mounts without disrupting ancillary stack services | Low | 3 |
| 4 | Verify filesystem access and Python `LocalSandboxProvider` mappings | Proves container and Python sandbox provider can resolve and map host repositories | Low | 4 |

## Root Cause — 5 Whys (Deterministic (Bohrbug) regime only)

1. **What fails:** DeerFlow agents and gateway cannot access or explore projects under `/home/leodev/repos` (e.g. `iodesk-lite`, `goro`, `agent-server`).
2. **Why:** The gateway container `deer-flow-gateway` had no volume mount for `/home/leodev/repos` in `docker/docker-compose-dev.yaml`.
3. **Why:** When DeerFlow runs inside Docker, any host path declared in `config.yaml` must also be mounted into the gateway container; otherwise `LocalSandboxProvider._setup_path_mappings()` rejects the path because `host_path` does not exist from the perspective of the gateway process.
4. **Why:** The compose volume declarations only mounted the deer-flow source, backend virtual environment, skills, and logs, omitting host workspace repositories.
5. **Why:** Host repository development was not previously wired into the containerized gateway dev compose specification.

**Refuting prediction:** If `docker exec deer-flow-gateway ls -la /home/leodev/repos/` succeeds and `LocalSandboxProvider()._setup_path_mappings()` produces `/workspace/repos` (or repo paths) without warning that the path does not exist, the bug is resolved.

**Invariant to create:** `/home/leodev/repos` is cleanly bind-mounted into `deer-flow-gateway` (at `/home/leodev/repos` and `/repos`) with read-write permissions, and `config.yaml` maps `/home/leodev/repos` to `/workspace/repos`.

## Invariants

- DRY: Single canonical mount declaration for the repos root across compose and sandbox config.
- SOLID / SRP: Docker Compose handles host-to-container virtualization; LocalSandboxProvider handles container-to-sandbox path virtualization.
- LEAN + KISS: Direct bind mounts without intermediate sync agents or heavy volume plugins.
- SSOT: `docker/docker-compose-dev.yaml` defines container volumes; `config.yaml` defines sandbox mount mappings.
- Poka-Yoke: Automated verification script checks filesystem paths and LocalSandboxProvider mappings inside the running container.

---

## Phase 1: Update `docker/docker-compose-dev.yaml`

**Goal:** Bind-mount `/home/leodev/repos` into the `gateway` service.

- [x] Task 1.1: Add `/home/leodev/repos:/home/leodev/repos:rw` and `/home/leodev/repos:/repos:rw` to `services.gateway.volumes`.

**Acceptance:** `grep -q "/home/leodev/repos:/home/leodev/repos:rw" docker/docker-compose-dev.yaml`

## Phase 2: Update `config.yaml`

**Goal:** Configure `sandbox.mounts` to include `/home/leodev/repos -> /workspace/repos`.

- [x] Task 2.1: Update `mounts:` in `config.yaml` under `sandbox:` with `/home/leodev/repos -> /workspace/repos` (rw).

**Acceptance:** `grep -q "/home/leodev/repos" config.yaml`

## Phase 3: Container Recreation & Verification

**Goal:** Recreate gateway container and verify both filesystem visibility and `LocalSandboxProvider` mappings.

- [x] Task 3.1: Run `docker compose -f docker/docker-compose-dev.yaml up -d --no-deps gateway`.
- [x] Task 3.2: Verify container filesystem access (`docker exec deer-flow-gateway ls -la /home/leodev/repos/` and `/repos/`).
- [x] Task 3.3: Verify Python `LocalSandboxProvider` path mappings.

**Acceptance:**
```bash
docker exec deer-flow-gateway ls -la /home/leodev/repos/iodesk-lite
docker exec deer-flow-gateway ls -la /repos/agent-server
docker exec deer-flow-gateway python -c '
from deerflow.sandbox.local.local_sandbox_provider import LocalSandboxProvider
provider = LocalSandboxProvider()
mappings = provider._setup_path_mappings()
containers = [m.container_path for m in mappings]
print("Found container path mappings:", containers)
assert any("repos" in c for c in containers), "Repos mapping missing from provider"
print("SUCCESS: LocalSandboxProvider successfully maps repos")
'
```

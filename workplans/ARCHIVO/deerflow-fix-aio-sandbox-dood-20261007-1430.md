# Workplan: deerflow-fix-aio-sandbox-dood

**Created:** 2026-10-07 14:30
**Target:** DeerFlow (`docker/docker-compose-dev.yaml`, `config.yaml`)
**Investigaciones consulted:** DeerFlow AIO Sandbox Provider (`backend/packages/harness/deerflow/community/aio_sandbox/aio_sandbox_provider.py`), Docker Compose configuration (`docker/docker-compose-dev.yaml`), Sandbox Config (`config.yaml`).

## Regime

**Regime:** Deterministic (Bohrbug) — Missing socket bind mount in Docker Compose prevented gateway from accessing host Docker daemon.

## Pareto Focus

The 20% of touchpoints carrying the 80% of impact (enabling Docker-out-of-Docker access in gateway container and verifying all-in-one-sandbox container lifecycle):

| # | Touchpoint | Impact if fixed | Effort | Rank |
|---|---|---|---|---|
| 1 | Add `/var/run/docker.sock:/var/run/docker.sock` to `services.gateway.volumes` in `docker/docker-compose-dev.yaml` | Enables DooD so gateway container can communicate with Docker Engine to run sandboxes | Low | 1 |
| 2 | Ensure `all-in-one-sandbox:1.11.0` image is available locally | Prevents download timeouts or runtime failures when spawning sandbox containers | Low | 2 |
| 3 | Recreate gateway container with compose `--no-deps` | Applies new socket volume mount without disrupting ancillary services | Low | 3 |
| 4 | Verify sandbox acquisition and command execution via Python provider | Proves end-to-end sandbox lifecycle and ability to read `/workspace/goro` | Low | 4 |

## Root Cause — 5 Whys (Deterministic (Bohrbug) regime only)

1. **What fails:** `AioSandboxProvider` failed to acquire sandboxes or communicate with Docker daemon inside the gateway container.
2. **Why:** The gateway container `deer-flow-gateway` did not have `/var/run/docker.sock` mounted in `docker/docker-compose-dev.yaml`.
3. **Why:** Docker socket was previously excluded by default from the base dev compose specification (relying on optional overlays).
4. **Why:** When running DeerFlow dev gateway in containerized mode with DooD sandbox provider enabled in `config.yaml`, the gateway process inside the container cannot interact with Docker Engine without direct socket access.
5. **Why:** DooD configuration was not unified directly in `docker/docker-compose-dev.yaml` for local development workflow.

**Refuting prediction:** If `/var/run/docker.sock` is mounted into `deer-flow-gateway` and `AioSandboxProvider().acquire()` succeeds and executes commands inside `all-in-one-sandbox` reading `/workspace/goro`, the root cause is confirmed and resolved.

**Invariant to create:** `/var/run/docker.sock:/var/run/docker.sock` is mounted in `deer-flow-gateway`, and `AioSandboxProvider` can acquire sandboxes and execute commands inspecting mounted repositories.

## Invariants

- DRY: Single canonical mount declaration for the Docker socket in compose.
- SOLID / SRP: Docker Compose handles container engine virtualization (DooD); AioSandboxProvider manages sandbox lifecycle.
- LEAN + KISS: Direct socket mount without external proxy daemons or heavy orchestration.
- SSOT: `docker/docker-compose-dev.yaml` defines gateway container volumes; `config.yaml` defines sandbox configuration.
- Poka-Yoke: End-to-end automated verification script acquires sandbox and asserts filesystem visibility on `/workspace/goro`.

---

## Phase 1: Update `docker/docker-compose-dev.yaml`

**Goal:** Mount `/var/run/docker.sock` into the `gateway` service.

- [x] Task 1.1: Add `- /var/run/docker.sock:/var/run/docker.sock` under `services.gateway.volumes` in `docker/docker-compose-dev.yaml`.

**Acceptance:** `grep -q "/var/run/docker.sock:/var/run/docker.sock" docker/docker-compose-dev.yaml`

## Phase 2: Pull Sandbox Image

**Goal:** Ensure `all-in-one-sandbox:1.11.0` is pulled and available to the host Docker daemon.

- [x] Task 2.1: Pull image `all-in-one-sandbox:1.11.0`.

**Acceptance:** `docker image inspect all-in-one-sandbox:1.11.0`

## Phase 3: Gateway Recreation & Verification

**Goal:** Recreate gateway container and verify sandbox provider lifecycle end-to-end.

- [x] Task 3.1: Recreate gateway container (`docker compose -f docker/docker-compose-dev.yaml up -d --no-deps gateway`).
- [x] Task 3.2: Verify DooD sandbox acquisition and command execution reading `/workspace/goro`.

**Acceptance:**
```bash
docker exec deer-flow-gateway /app/backend/.venv/bin/python -c '
import sys
sys.path.insert(0, "/app/backend")
from deerflow.sandbox import get_sandbox_provider
provider = get_sandbox_provider()
sandbox_id = provider.acquire(thread_id="test-verify-goro", user_id="18106577-16b4-4fca-96ee-8f57a56c75f1")
print("Acquired sandbox:", sandbox_id)
sb = provider.get(sandbox_id)
assert sb is not None, "Failed to get sandbox"
res = sb.execute_command("ls -la /workspace/goro")
print("Output of ls /workspace/goro:\n" + str(res))
assert "go.mod" in res, "Failed to find go.mod in /workspace/goro"
provider.release(sandbox_id)
print("SUCCESS: End-to-end sandbox verification passed!")
'
```

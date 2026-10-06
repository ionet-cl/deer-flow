#!/usr/bin/env bash
# ==============================================================================
# scripts/sync-custom-agents.sh
#
# Idempotently syncs custom agent definitions from custom-agents/ into:
# 1) backend/.deer-flow/agents/ (global agent templates)
# 2) backend/.deer-flow/users/*/agents/ (active user agent stores)
#
# Enforces non-root container UID:GID ownership (1003:1003).
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

SRC_DIR="${REPO_ROOT}/custom-agents"
GLOBAL_DEST="${REPO_ROOT}/backend/.deer-flow/agents"
USERS_ROOT="${REPO_ROOT}/backend/.deer-flow/users"

TARGET_UID=1003
TARGET_GID=1003

if [[ ! -d "${SRC_DIR}" ]]; then
  echo "Error: Source directory '${SRC_DIR}' does not exist." >&2
  exit 1
fi

echo "=== Syncing custom agents from ${SRC_DIR} ==="

# 1. Sync to global agent store
mkdir -p "${GLOBAL_DEST}"
for agent_path in "${SRC_DIR}"/*; do
  if [[ -d "${agent_path}" ]]; then
    agent_name="$(basename "${agent_path}")"
    dest_dir="${GLOBAL_DEST}/${agent_name}"
    mkdir -p "${dest_dir}"
    cp -r "${agent_path}/." "${dest_dir}/"
    echo "  [global] Synced agent: ${agent_name}"
  fi
done

# 2. Sync to active user stores
if [[ -d "${USERS_ROOT}" ]]; then
  for user_dir in "${USERS_ROOT}"/*; do
    if [[ -d "${user_dir}" ]]; then
      user_id="$(basename "${user_dir}")"
      user_agents_dest="${user_dir}/agents"
      mkdir -p "${user_agents_dest}"
      for agent_path in "${SRC_DIR}"/*; do
        if [[ -d "${agent_path}" ]]; then
          agent_name="$(basename "${agent_path}")"
          dest_dir="${user_agents_dest}/${agent_name}"
          mkdir -p "${dest_dir}"
          cp -r "${agent_path}/." "${dest_dir}/"
        fi
      done
      echo "  [user:${user_id}] Synced all custom agents"
    fi
  done
fi

# 3. Apply ownership (1003:1003)
echo "=== Enforcing ownership ${TARGET_UID}:${TARGET_GID} ==="
set_ownership() {
  local target_path="$1"
  if [[ -e "${target_path}" ]]; then
    if chown -R "${TARGET_UID}:${TARGET_GID}" "${target_path}" 2>/dev/null; then
      return 0
    elif command -v docker >/dev/null 2>&1 && docker ps --format '{{.Names}}' | grep -q '^deer-flow-gateway$'; then
      # Convert repo path to container path (/app/...)
      local rel_path="${target_path#${REPO_ROOT}/}"
      docker exec deer-flow-gateway chown -R "${TARGET_UID}:${TARGET_GID}" "/app/${rel_path}" 2>/dev/null || true
    fi
  fi
}

set_ownership "${GLOBAL_DEST}"
if [[ -d "${USERS_ROOT}" ]]; then
  set_ownership "${USERS_ROOT}"
fi

echo "=== Custom agents sync complete. ==="

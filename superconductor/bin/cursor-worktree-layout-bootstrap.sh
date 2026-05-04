#!/bin/bash
set -euo pipefail

ROOT_PATH="${1:-${SUPERCONDUCTOR_ROOT_PATH:-}}"
WORKTREE_PATH="${2:-$(pwd -P)}"
WS_ROOT="$HOME/Library/Application Support/Cursor/User/workspaceStorage"

if [ -z "$ROOT_PATH" ] || [ ! -d "$ROOT_PATH" ]; then
  exit 0
fi

if [ ! -d "$WS_ROOT" ]; then
  exit 0
fi

if ! command -v node >/dev/null 2>&1; then
  exit 0
fi

if ! command -v sqlite3 >/dev/null 2>&1; then
  exit 0
fi

ROOT_PATH="$(cd "$ROOT_PATH" && pwd -P)"
WORKTREE_PATH="$(cd "$WORKTREE_PATH" && pwd -P)"

if [ "$ROOT_PATH" = "$WORKTREE_PATH" ]; then
  exit 0
fi

find_workspace_dir() {
  local target_path="$1"
  node - "$target_path" "$WS_ROOT" <<'JS'
const fs = require("fs");
const path = require("path");
const { pathToFileURL } = require("url");

const targetPath = process.argv[2];
const wsRoot = process.argv[3];
const targetUri = pathToFileURL(targetPath).href;

try {
  for (const name of fs.readdirSync(wsRoot)) {
    const dir = path.join(wsRoot, name);
    const workspaceJson = path.join(dir, "workspace.json");
    const stateDb = path.join(dir, "state.vscdb");
    if (!fs.existsSync(workspaceJson) || !fs.existsSync(stateDb)) continue;

    try {
      const folder = JSON.parse(fs.readFileSync(workspaceJson, "utf8")).folder;
      if (folder === targetUri) {
        process.stdout.write(dir);
        process.exit(0);
      }
    } catch {
      // Ignore malformed workspace entries.
    }
  }
} catch {
  // Ignore lookup failures.
}

process.exit(1);
JS
}

MAIN_WS_DIR="$(find_workspace_dir "$ROOT_PATH" 2>/dev/null || true)"
if [ -z "$MAIN_WS_DIR" ] || [ ! -f "$MAIN_WS_DIR/state.vscdb" ]; then
  exit 0
fi

TARGET_WS_DIR=""
for _ in $(seq 1 120); do
  TARGET_WS_DIR="$(find_workspace_dir "$WORKTREE_PATH" 2>/dev/null || true)"
  if [ -n "$TARGET_WS_DIR" ] && [ -f "$TARGET_WS_DIR/state.vscdb" ]; then
    break
  fi
  sleep 1
done

if [ -z "$TARGET_WS_DIR" ] || [ ! -f "$TARGET_WS_DIR/state.vscdb" ]; then
  exit 0
fi

MAIN_DB="$MAIN_WS_DIR/state.vscdb"
TARGET_DB="$TARGET_WS_DIR/state.vscdb"

MAIN_DB_SQL=${MAIN_DB//\'/\'\'}

sqlite3 "$TARGET_DB" "
ATTACH DATABASE '$MAIN_DB_SQL' AS src;
INSERT INTO ItemTable(key, value)
SELECT key, value
FROM src.ItemTable
WHERE key LIKE 'workbench.sideBar.%'
   OR key LIKE 'workbench.panel.%'
   OR key LIKE 'workbench.activityBar.%'
   OR key LIKE 'workbench.unifiedSidebar.%'
   OR key LIKE 'workbench.auxiliarybar.%'
   OR key LIKE 'cursor/agentLayout.%'
   OR key LIKE 'cursor/editorLayout.%'
   OR key LIKE 'newAgentSidebar.%'
ON CONFLICT(key) DO UPDATE SET value = excluded.value;
DETACH DATABASE src;
" >/dev/null 2>&1 || true

exit 0

#!/usr/bin/env bash
set -euo pipefail

ROOT_PATH="${1:-${SUPERCONDUCTOR_ROOT_PATH:-}}"
WORKTREE_PATH="${2:-$(pwd -P)}"

if [ -z "$WORKTREE_PATH" ] || [ ! -d "$WORKTREE_PATH" ]; then
  exit 0
fi

WORKTREE_PATH="$(cd "$WORKTREE_PATH" && pwd -P)"

if [ -n "$ROOT_PATH" ] && [ -d "$ROOT_PATH" ]; then
  ROOT_PATH="$(cd "$ROOT_PATH" && pwd -P)"
fi

if [ -n "$ROOT_PATH" ] && [ -d "$ROOT_PATH" ] && [ -x "$HOME/.superconductor/bin/cursor-worktree-layout-bootstrap.sh" ]; then
  bash "$HOME/.superconductor/bin/cursor-worktree-layout-bootstrap.sh" "$ROOT_PATH" "$WORKTREE_PATH" >/dev/null 2>&1 &
fi

if [ -z "$ROOT_PATH" ] || [ ! -f "$ROOT_PATH/.env" ]; then
  exit 0
fi

cp "$ROOT_PATH/.env" "$WORKTREE_PATH/.env"
cp "$ROOT_PATH/.env" "$WORKTREE_PATH/.envrc"

if command -v direnv >/dev/null 2>&1; then
  (
    cd "$WORKTREE_PATH"
    direnv allow >/dev/null 2>&1
  ) || true
fi

exit 0

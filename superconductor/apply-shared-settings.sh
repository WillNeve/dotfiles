#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/code/dotfiles}"
SC_DIR="$HOME/.superconductor"
SETTINGS_PATH="$SC_DIR/settings.json"
SHARED_PATH="$DOTFILES_DIR/superconductor/settings.shared.json"
BOOTSTRAP_CMD='bash "$HOME/.superconductor/bin/cursor-worktree-layout-bootstrap.sh" "$SUPERCONDUCTOR_ROOT_PATH" "$(pwd -P)" >/dev/null 2>&1 &'
ENV_CMD='if [ -f "$SUPERCONDUCTOR_ROOT_PATH/.env" ]; then cp "$SUPERCONDUCTOR_ROOT_PATH/.env" "$SUPERCONDUCTOR_ROOT_PATH/.envrc" . && direnv allow; fi'
LEGACY_ENV_CMD='cp "$SUPERCONDUCTOR_ROOT_PATH/.env" "$SUPERCONDUCTOR_ROOT_PATH/.envrc" . && direnv allow'

mkdir -p "$SC_DIR"

if ! command -v jq >/dev/null 2>&1; then
  echo "Warning: jq not found; skipping Superconductor shared settings merge"
  exit 0
fi

if [ ! -f "$SHARED_PATH" ]; then
  echo "Warning: shared Superconductor settings not found at $SHARED_PATH"
  exit 0
fi

if [ -L "$SETTINGS_PATH" ]; then
  rm -f "$SETTINGS_PATH"
fi

if [ -f "$SETTINGS_PATH" ] && [ ! -L "$SETTINGS_PATH" ]; then
  :
elif [ -e "$SETTINGS_PATH" ]; then
  rm -f "$SETTINGS_PATH"
fi

if [ ! -f "$SETTINGS_PATH" ]; then
  echo '{}' > "$SETTINGS_PATH"
fi

tmp_file="$SC_DIR/settings.json.tmp.$(date +%s)"

jq --arg bootstrapCmd "$BOOTSTRAP_CMD" --arg envCmd "$ENV_CMD" --arg legacyEnvCmd "$LEGACY_ENV_CMD" -s '
  .[0] * .[1]
  | .projects = ((.projects // []) | map(
      if (.settings | type) == "object" then
        .settings.setup_scripts = (((.settings.setup_scripts // [])
          | map(select(. != $legacyEnvCmd))
          | . + [$envCmd, $bootstrapCmd]) | unique)
      else
        .
      end
    ))
' "$SETTINGS_PATH" "$SHARED_PATH" > "$tmp_file"

mv "$tmp_file" "$SETTINGS_PATH"
echo "Applied shared Superconductor settings"

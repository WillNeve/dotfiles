#!/bin/bash

# load.sh - Load and setup dotfiles scripts
# This script programmatically creates aliases for all scripts in subdirectories

SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"

load_dotfiles_scripts() {
  for subdir in "$SCRIPTS_DIR"/*; do
    [[ -d "$subdir" ]] || continue

    local subdir_name
    subdir_name="$(basename "$subdir")"

    local script_paths=()
    if [[ -n "${ZSH_VERSION:-}" ]]; then
      setopt local_options null_glob
      script_paths=("$subdir"/*.sh)
    else
      shopt -s nullglob 2>/dev/null
      script_paths=("$subdir"/*.sh)
      shopt -u nullglob 2>/dev/null
    fi

    for script in "${script_paths[@]}"; do
      [[ -f "$script" ]] || continue

      chmod +x "$script"

      local script_name
      script_name="$(basename "$script" .sh)"

      alias "$script_name"="$script"

      if [[ "$(basename "$script")" == "main.sh" ]]; then
        alias "$subdir_name"="$script"
      fi
    done
  done
}

load_dotfiles_scripts

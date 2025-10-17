#!/bin/bash

# load.sh - Load and setup dotfiles scripts
# This script programmatically creates aliases for all scripts in subdirectories

SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"

# Iterate through each subdirectory in scripts (1 level deep)
for subdir in "$SCRIPTS_DIR"/*; do
  if [[ -d "$subdir" ]]; then
    local subdir_name=$(basename "$subdir")

    # Process all .sh files in the subdirectory
    for script in "$subdir"/*.sh; do
      if [[ -f "$script" ]]; then
        # Make script executable
        chmod +x "$script"

        # Create alias based on script filename (without .sh extension)
        local script_name=$(basename "$script" .sh)
        alias "$script_name"="$script"
      fi
    done
  fi
done

#!/bin/bash

# Check if exactly one argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <session_name>"
    echo "Runs the corresponding session script from the sessions folder"
    exit 1
fi

session_name="$1"
script_dir="$(dirname "$0")"
sessions_dir="$script_dir/sessions"
session_script="$sessions_dir/$session_name.sh"

# Check if the session script exists
if [ ! -f "$session_script" ]; then
    echo "Error: Session script '$session_name.sh' not found in sessions folder"
    echo "Available sessions:"
    ls -1 "$sessions_dir"/*.sh 2>/dev/null | xargs -n1 basename -s .sh 2>/dev/null || echo "  (none)"
    exit 1
fi

# Ensure all session scripts are executable
chmod +x "$sessions_dir"/*.sh 2>/dev/null

# Change to sessions directory and run the script
cd "$sessions_dir" || exit 1
exec "./$session_name.sh"

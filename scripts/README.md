# Scripts

This directory contains utility scripts.

## Setup

The `load.sh` script is sourced by `.zshrc` and automatically:

- Makes all scripts in subdirectories executable
- Creates aliases for each script (using filename without .sh extension)

To add a new script:

1. Create a subdirectory (e.g., `scripts/my-tool/`)
2. Add your script (e.g., `my-tool.sh`)
3. Reload your shell (`source ~/.zshrc`) or restart your terminal
4. The script will be available as an alias (e.g., `my-tool`)

## Available Scripts

- `tm/` - Tmux session manager

  - `tm <session-name>` - Launch predefined tmux sessions
  - Sessions available: `fyxer-w`, `fyxer-marketing`

- `kill-port/` - Kill process running on a port
  - `kill-port <port-number>` - Kill the process using the specified port

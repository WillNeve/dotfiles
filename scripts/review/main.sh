#!/bin/bash

set -euo pipefail

# Capture the original working directory before any cd operations
export ORIGINAL_CWD="$(pwd)"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$SCRIPTS_ROOT"
npx tsx "$SCRIPT_DIR/main.ts" "$@"

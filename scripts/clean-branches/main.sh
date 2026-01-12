#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

npx tsx --tsconfig "$SCRIPTS_ROOT/tsconfig.json" "$SCRIPT_DIR/main.ts" "$@"

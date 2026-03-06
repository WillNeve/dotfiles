#!/bin/bash

# load-env.sh - Load environment variables from .env file
# This script loads from .env first, then allows local overrides

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$DOTFILES_DIR/.env"

# Load .env if it exists
if [ -f "$ENV_FILE" ]; then
  # Export variables from .env (non-empty lines, skip comments)
  while IFS='=' read -r key value; do
    # Skip empty lines and comments
    [[ -z "$key" ]] && continue
    [[ "$key" =~ ^[[:space:]]*# ]] && continue
    
    # Trim whitespace
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)
    
    # Skip if value is empty (allow local override)
    [[ -z "$value" ]] && continue
    
    # Only set if not already set (allow local env to override)
    if [ -z "${!key}" ]; then
      export "$key"="$value"
    fi
  done < "$ENV_FILE"
fi

# Also load .env.local if it exists (for local overrides)
ENV_LOCAL="$DOTFILES_DIR/.env.local"
if [ -f "$ENV_LOCAL" ]; then
  while IFS='=' read -r key value; do
    [[ -z "$key" ]] && continue
    [[ "$key" =~ ^[[:space:]]*# ]] && continue
    
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)
    
    [[ -z "$value" ]] && continue
    export "$key"="$value"
  done < "$ENV_LOCAL"
fi

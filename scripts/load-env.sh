#!/bin/zsh

# load-env.sh - Load .env, then allow local envs to override
# set -a causes all variables to be auto-exported to child processes

DOTFILES_DIR="${0:a:h}/.."

set -a
[[ -f "$DOTFILES_DIR/.env" ]] && source "$DOTFILES_DIR/.env"
[[ -f "$DOTFILES_DIR/.env.local" ]] && source "$DOTFILES_DIR/.env.local"
set +a

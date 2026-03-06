#!/bin/zsh

# load-env.sh - Load .env, then allow local envs to override

DOTFILES_DIR="${0:a:h}/.."

[[ -f "$DOTFILES_DIR/.env" ]] && source "$DOTFILES_DIR/.env"
[[ -f "$DOTFILES_DIR/.env.local" ]] && source "$DOTFILES_DIR/.env.local"

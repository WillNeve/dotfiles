#!/usr/bin/env bash

DOTFILES_DIR="$HOME/code/dotfiles"
OPENCODE_SKILLS_SOURCE="$DOTFILES_DIR/opencode/skills"
OPENCODE_SKILLS_CANONICAL="$HOME/.agents/skills"
OPENCODE_SKILLS_COMPAT="$HOME/.config/opencode/skills"

symlinks=(
  "$DOTFILES_DIR/zsh/.zshrc|$HOME/.zshrc"
  "$DOTFILES_DIR/zsh/.aliases|$HOME/.aliases"
  "$DOTFILES_DIR/p10k/.p10k.zsh|$HOME/.p10k.zsh"
  "$DOTFILES_DIR/git/.gitconfig|$HOME/.gitconfig"
  "$DOTFILES_DIR/git/.gitignore_global|$HOME/.gitignore"
  "$DOTFILES_DIR/tmux/.tmux.conf|$HOME/.tmux.conf"
  "$DOTFILES_DIR/github/config.yml|$HOME/.config/gh/config.yml"
  "$DOTFILES_DIR/github/hosts.yml|$HOME/.config/gh/hosts.yml"
  "$DOTFILES_DIR/ghostty/config|$HOME/Library/Application Support/com.mitchellh.ghostty/config"
  "$DOTFILES_DIR/neofetch/config.conf|$HOME/.config/neofetch/config.conf"
  "$DOTFILES_DIR/htop/htoprc|$HOME/.config/htop/htoprc"
  "$DOTFILES_DIR/opencode/opencode.json|$HOME/.config/opencode/opencode.json"
  "$DOTFILES_DIR/opencode/AGENTS.md|$HOME/.config/opencode/AGENTS.md"
  "$DOTFILES_DIR/superconductor/bin/cursor-worktree-layout-bootstrap.sh|$HOME/.superconductor/bin/cursor-worktree-layout-bootstrap.sh"
  "$DOTFILES_DIR/superconductor/bin/cursor-worktree-post-setup.sh|$HOME/.superconductor/bin/cursor-worktree-post-setup.sh"
)

force_symlink_with_backup() {
  local source="$1"
  local target="$2"
  local target_dir

  target_dir="$(dirname "$target")"
  mkdir -p "$target_dir"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local backup
    backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
    mv "$target" "$backup"
    echo "↺ Backed up existing path: $target -> $backup"
  fi

  ln -sfn "$source" "$target"
  echo "✓ Linked: $target -> $source"
}

echo "Creating symlinks for dotfiles..."

for entry in "${symlinks[@]}"; do
  IFS='|' read -r source target <<< "$entry"
  target_dir="$(dirname "$target")"
  
  mkdir -p "$target_dir"
  
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Warning: $target exists and is not a symlink. Skipping..."
    continue
  fi
  
  ln -sf "$source" "$target"
  echo "✓ Linked: $target -> $source"
done

if [ -d "$OPENCODE_SKILLS_SOURCE" ]; then
  echo "Linking OpenCode skills via ~/.agents/skills..."
  force_symlink_with_backup "$OPENCODE_SKILLS_SOURCE" "$OPENCODE_SKILLS_CANONICAL"
  force_symlink_with_backup "$OPENCODE_SKILLS_CANONICAL" "$OPENCODE_SKILLS_COMPAT"
else
  echo "Warning: OpenCode skills source not found at $OPENCODE_SKILLS_SOURCE"
fi

if [ -x "$DOTFILES_DIR/superconductor/apply-shared-settings.sh" ]; then
  echo "Applying shared Superconductor settings..."
  DOTFILES_DIR="$DOTFILES_DIR" "$DOTFILES_DIR/superconductor/apply-shared-settings.sh"
else
  echo "Warning: Superconductor shared settings script not found at $DOTFILES_DIR/superconductor/apply-shared-settings.sh"
fi

echo "Dotfiles symlinks created successfully!"

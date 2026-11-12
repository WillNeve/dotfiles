#!/usr/bin/env bash

DOTFILES_DIR="$HOME/code/dotfiles"
SKILLS_SOURCE="$DOTFILES_DIR/skills"
SKILLS_CANONICAL="$HOME/.agents/skills"
OPENCODE_SKILLS_COMPAT="$HOME/.config/opencode/skills"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_SKILLS_DIR="$CLAUDE_DIR/skills"

symlinks=(
  "$DOTFILES_DIR/zsh/.zshrc|$HOME/.zshrc"
  "$DOTFILES_DIR/zsh/.aliases|$HOME/.aliases"
  "$DOTFILES_DIR/git/.gitconfig|$HOME/.gitconfig"
  "$DOTFILES_DIR/git/.gitignore_global|$HOME/.gitignore"
  "$DOTFILES_DIR/tmux/.tmux.conf|$HOME/.tmux.conf"
  "$DOTFILES_DIR/github/config.yml|$HOME/.config/gh/config.yml"
  "$DOTFILES_DIR/github/hosts.yml|$HOME/.config/gh/hosts.yml"
  "$DOTFILES_DIR/ghostty/config|$HOME/.config/ghostty/config"
  "$DOTFILES_DIR/neofetch/config.conf|$HOME/.config/neofetch/config.conf"
  "$DOTFILES_DIR/htop/htoprc|$HOME/.config/htop/htoprc"
  "$DOTFILES_DIR/cursor/settings.json|$HOME/Library/Application Support/Cursor/User/settings.json"
  "$DOTFILES_DIR/cursor/keybindings.json|$HOME/Library/Application Support/Cursor/User/keybindings.json"
  "$DOTFILES_DIR/opencode/opencode.json|$HOME/.config/opencode/opencode.json"
  "$DOTFILES_DIR/opencode/AGENTS.md|$HOME/.config/opencode/AGENTS.md"
  "$DOTFILES_DIR/superconductor/bin/cursor-worktree-layout-bootstrap.sh|$HOME/.super.engineering/bin/cursor-worktree-layout-bootstrap.sh"
  "$DOTFILES_DIR/superconductor/bin/cursor-worktree-post-setup.sh|$HOME/.super.engineering/bin/cursor-worktree-post-setup.sh"
  "$DOTFILES_DIR/zen/zen-backup.sh|$HOME/.local/bin/zen-backup.sh"
  "$DOTFILES_DIR/zen/zen-export-pins-to-bookmarks.sh|$HOME/.local/bin/zen-export-pins-to-bookmarks.sh"
  "$DOTFILES_DIR/zen/zen-restore-pins-from-bookmarks.sh|$HOME/.local/bin/zen-restore-pins-from-bookmarks.sh"
  "$DOTFILES_DIR/zen/com.willneve.zen-backup.plist|$HOME/Library/LaunchAgents/com.willneve.zen-backup.plist"
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

if [ -d "$SKILLS_SOURCE" ]; then
  echo "Linking skills via ~/.agents/skills..."
  force_symlink_with_backup "$SKILLS_SOURCE" "$SKILLS_CANONICAL"
  force_symlink_with_backup "$SKILLS_CANONICAL" "$OPENCODE_SKILLS_COMPAT"

  # ~/.claude/skills also holds Claude-managed dirs (e.g. synced/), so link each skill individually
  echo "Linking skills into ~/.claude/skills..."
  mkdir -p "$CLAUDE_SKILLS_DIR"
  for skill_dir in "$SKILLS_SOURCE"/*/; do
    skill_dir="${skill_dir%/}"
    force_symlink_with_backup "$skill_dir" "$CLAUDE_SKILLS_DIR/$(basename "$skill_dir")"
  done

  # Prune links to skills that have since been removed from dotfiles
  for link in "$CLAUDE_SKILLS_DIR"/*; do
    if [ -L "$link" ] && [ ! -e "$link" ] && [[ "$(readlink "$link")" == "$SKILLS_SOURCE"/* ]]; then
      rm "$link"
      echo "✗ Removed stale skill link: $link"
    fi
  done
else
  echo "Warning: skills source not found at $SKILLS_SOURCE"
fi

if [ -x "$DOTFILES_DIR/superconductor/apply-shared-settings.sh" ]; then
  echo "Applying shared Superconductor settings..."
  DOTFILES_DIR="$DOTFILES_DIR" "$DOTFILES_DIR/superconductor/apply-shared-settings.sh"
else
  echo "Warning: Superconductor shared settings script not found at $DOTFILES_DIR/superconductor/apply-shared-settings.sh"
fi

echo "Dotfiles symlinks created successfully!"
echo ""
echo "=== Post-install steps (run manually) ==="
echo ""
echo "1. Install Homebrew packages:"
echo "   brew bundle --file=$DOTFILES_DIR/brew/Brewfile"
echo ""
echo "2. Install JetBrains Mono Nerd Font:"
echo "   brew install --cask font-jetbrains-mono-nerd-font"
echo ""
echo "3. Install and set up NVM Node versions:"
echo "   nvm install 22.17.1"
echo "   nvm install 18.20.8"
echo "   nvm alias default 22.17.1"
echo ""
echo "4. Restore .env from backup:"
echo "   Copy your saved .env to $DOTFILES_DIR/.env"
echo ""
echo "5. Load the zen-backup launchd agent:"
echo "   launchctl load $HOME/Library/LaunchAgents/com.willneve.zen-backup.plist"

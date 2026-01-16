#!/usr/bin/env bash

DOTFILES_DIR="$HOME/code/dotfiles"

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
)

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

echo "Dotfiles symlinks created successfully!"

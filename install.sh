#!/bin/bash
# Install script for dotfiles

echo "Creating symlinks for dotfiles..."

# Zsh configuration
ln -sf ~/willneve/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/willneve/dotfiles/zsh/.aliases ~/.aliases

# P10k configuration
ln -sf ~/willneve/dotfiles/p10k/.p10k.zsh ~/.p10k.zsh

# Git configuration
ln -sf ~/willneve/dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/willneve/dotfiles/git/.gitignore_global ~/.gitignore

# Tmux configuration
ln -sf ~/willneve/dotfiles/tmux/.tmux.conf ~/.tmux.conf

# Create config directories if they don't exist
mkdir -p ~/.config/gh ~/.config/ghostty ~/.config/neofetch

# GitHub CLI configuration
ln -sf ~/willneve/dotfiles/github/config.yml ~/.config/gh/config.yml
ln -sf ~/willneve/dotfiles/github/hosts.yml ~/.config/gh/hosts.yml

# Ghostty configuration
ln -sf ~/willneve/dotfiles/ghostty/config ~/.config/ghostty/config

# Neofetch configuration
ln -sf ~/willneve/dotfiles/neofetch/config.conf ~/.config/neofetch/config.conf

echo "Dotfiles symlinks created successfully!"

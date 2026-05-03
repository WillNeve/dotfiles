# Dotfiles

Development configuration files for [willneve](github.com/willneve)

## Installation

Run `./install.sh` to create symlinks to home directory

## Docs

- `docs/README.md` - Documentation index
- `docs/opencode/README.md` - OpenCode architecture and config model

## Manual symlinks

```bash
ln -s ~/code/dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/code/dotfiles/zsh/.aliases ~/.aliases
ln -s ~/code/dotfiles/p10k/.p10k.zsh ~/.p10k.zsh
ln -s ~/code/dotfiles/git/.gitconfig ~/.gitconfig
ln -s ~/code/dotfiles/git/.gitignore_global ~/.gitignore
ln -s ~/code/dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -s ~/code/dotfiles/github/config.yml ~/.config/gh/config.yml
ln -s ~/code/dotfiles/github/hosts.yml ~/.config/gh/hosts.yml
ln -s ~/code/dotfiles/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
ln -s ~/code/dotfiles/neofetch/config.conf ~/.config/neofetch/config.conf
ln -s ~/code/dotfiles/htop/htoprc ~/.config/htop/htoprc
ln -s ~/code/dotfiles/opencode/opencode.json ~/.config/opencode/opencode.json
ln -s ~/code/dotfiles/opencode/AGENTS.md ~/.config/opencode/AGENTS.md
ln -s ~/code/dotfiles/opencode/skills ~/.agents/skills
ln -s ~/.agents/skills ~/.config/opencode/skills
```

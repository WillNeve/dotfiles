# Dotfiles

Development configuration files for [willneve](github.com/willneve)

## Quick Start (Full Setup on a New Mac)

```bash
# 1. Install Xcode CLI tools
xcode-select --install

# 2. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Clone dotfiles
git clone git@github.com:WillNeve/dotfiles.git ~/code/dotfiles

# 4. Create symlinks
cd ~/code/dotfiles && ./install.sh

# 5. Install all packages (formula, casks, VSCode extensions, npm globals)
brew bundle --file=brew/Brewfile

# 6. Install JetBrains Mono Nerd Font
brew install --cask font-jetbrains-mono-nerd-font

# 7. Install NVM and Node versions
source ~/.zshrc
nvm install 22.17.1
nvm install 18.20.8
nvm alias default 22.17.1

# 8. Restore .env (copy from backup or password manager)
# Copy your saved secrets to ~/code/dotfiles/.env

# 9. Load launchd agents
launchctl load ~/Library/LaunchAgents/com.willneve.zen-backup.plist
```

## Structure

| Directory | What it tracks |
|-----------|---------------|
| `brew/` | Homebrew Brewfile (formula, casks, VSCode extensions, npm globals) |
| `cursor/` | Cursor editor settings and keybindings |
| `ghostty/` | Ghostty terminal emulator config |
| `git/` | Git config and global gitignore |
| `github/` | GitHub CLI (gh) config |
| `htop/` | htop process viewer config |
| `neofetch/` | neofetch system info config |
| `opencode/` | OpenCode AI agent config, AGENTS.md, and skills |
| `p10k/` | Powerlevel10k dark/light themes with auto-detection |
| `scripts/` | Utility scripts (git submodule) |
| `superconductor/` | Cursor worktree management |
| `tmux/` | Tmux config |
| `zen/` | Zen Browser backup scripts and launchd agent |
| `zsh/` | ZSH config and aliases |

## Before Wiping Your Mac

1. **Backup `.env`** — `~/.env` (repo file, gitignored). Save to a password manager.
2. **Commit and push** — ensure all changes are pushed to GitHub.
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

export COLORTERM=truecolor

# Set plugins
plugins=(
  git
  ssh-agent
  docker
  npm
  node
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Source aliases if file exists
if [ -f "$HOME/.aliases" ]; then
  source "$HOME/.aliases"
fi

export NVM_DIR=/Users/willneve/.nvm
[ -s /opt/homebrew/opt/nvm/nvm.sh ] && \. /opt/homebrew/opt/nvm/nvm.sh  # This loads nvm
[ -s /opt/homebrew/opt/nvm/etc/bash_completion.d/nvm ] && \. /opt/homebrew/opt/nvm/etc/bash_completion.d/nvm  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit the p10k configs.
# Theme-aware p10k configuration (auto-detects dark/light mode)
if [[ -f "$HOME/code/dotfiles/p10k/theme-detect.zsh" ]]; then
  source "$HOME/code/dotfiles/p10k/theme-detect.zsh"
elif [[ -f ~/.p10k.zsh ]]; then
  source ~/.p10k.zsh
fi

# Java
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
# Opencode
export PATH=/Users/willneve/.opencode/bin:$PATH
# Prioritize local node_modules/.bin over global packages
export PATH="./node_modules/.bin:$PATH"

# Auto-load dotfiles scripts
if [ -f "$HOME/code/dotfiles/scripts/load.sh" ]; then
  source "$HOME/code/dotfiles/scripts/load.sh"
fi

# Add this to your ~/.bashrc or ~/.zshrc
alias pip='python3 -m pip'

# Added by Windsurf
export PATH="/Users/willneve/.codeium/windsurf/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/willneve/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

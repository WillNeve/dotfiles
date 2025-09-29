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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Java
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
# Opencode
export PATH=/Users/willneve/.opencode/bin:$PATH
# Prioritize local node_modules/.bin over global packages
export PATH="./node_modules/.bin:$PATH"

# Auto-load dotfiles scripts
# Function to programmatically process scripts in /scripts subdirectories
load_dotfiles_scripts() {
  local scripts_dir="$HOME/willneve/dotfiles/scripts"

  # Check if scripts directory exists
  if [[ ! -d "$scripts_dir" ]]; then
    return
  fi

  # Iterate through each subdirectory in scripts (1 level deep)
  for subdir in "$scripts_dir"/*; do
    if [[ -d "$subdir" ]]; then
      local subdir_name=$(basename "$subdir")

      # Add subdirectory to PATH
      export PATH="$subdir:$PATH"

      # Process all .sh files in the subdirectory
      for script in "$subdir"/*.sh; do
        if [[ -f "$script" ]]; then
          # Make script executable
          chmod +x "$script"

          # Create alias based on script filename (without .sh extension)
          local script_name=$(basename "$script" .sh)
          alias "$script_name"="$script"
        fi
      done
    fi
  done
}

# Load all dotfiles scripts
load_dotfiles_scripts

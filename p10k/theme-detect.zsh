# Theme detection for macOS
# Detects system appearance (dark/light) and sources the appropriate p10k config

# Hardcode the p10k directory path for reliability
typeset -g P10K_DOTFILES_DIR="$HOME/code/dotfiles/p10k"

# Function to detect macOS appearance
detect_macos_theme() {
  if [[ "$(uname)" == "Darwin" ]]; then
    # Query macOS for current appearance
    local appearance
    appearance=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
    
    if [[ "$appearance" == "Dark" ]]; then
      echo "dark"
    else
      echo "light"
    fi
  else
    # Default to dark for non-macOS systems
    echo "dark"
  fi
}

# Function to source the appropriate p10k config
load_p10k_theme() {
  local theme=$(detect_macos_theme)
  
  if [[ "$theme" == "light" ]]; then
    [[ -f "$P10K_DOTFILES_DIR/.p10k-light.zsh" ]] && source "$P10K_DOTFILES_DIR/.p10k-light.zsh"
  else
    [[ -f "$P10K_DOTFILES_DIR/.p10k-dark.zsh" ]] && source "$P10K_DOTFILES_DIR/.p10k-dark.zsh"
  fi
}

# Export current theme for other tools to use
export TERM_THEME=$(detect_macos_theme)

# Load the appropriate p10k theme
load_p10k_theme

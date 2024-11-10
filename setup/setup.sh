#!/bin/zsh

# [Config]
USERNAME=$(whoami)
EMAIL="williamneve6000@gmail.com"
DOTFILES_DIR="$HOME/dotfiles"
CODE_SETTINGS_DIR=~/.vscode-server/data/Machine
SSH_DIR=~/.ssh
ZSH_PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"

backupFile() {
  target=$1
  if [ -e $target ] || [ -L $target ]; then
    mv $target "$target.backup"
  fi
}

symlink() {
  file=$1
  link=$2
  if [ ! -e "$link" ]; then
    ln -s $file $link
  fi
}

# [Up to date check]

echo -n "🔒 Running pre-setup checks ..."
sleep 0.5
git fetch
STATUS=$(git status --porcelain)
if [ -n "$STATUS" ]; then
  echo "⚠️ Aborting setup: Dotfiles repo is out of date with origin or there are uncommitted changes."
  exit 1
fi
echo -e "\r🔓 Pre-setup checks  passed, proceeding with setup script..."

# [Oh-My-ZSH Plugins]

mkdir -p "$ZSH_PLUGINS_DIR" && cd "$ZSH_PLUGINS_DIR"
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting
fi
cd "$DOTFILES_DIR"
echo "✅ Installed ZSH Plugins"
sleep 0.5

# [Symbolic Link Creation]

# Create Various sym-links in Root Path
HOME_SYMLINKS=("aliases" "gitconfig" "irbrc" "zshrc" "tmux.conf")
for name in "${HOME_SYMLINKS[@]}"; do
  if [ ! -d "$name" ]; then
    target="$HOME/.$name"
    backupFile "$target"
    symlink "$DOTFILES_DIR/$name" "$target"
  fi
done
echo "✅ Created Sym-Links in in $HOME for: ${HOME_SYMLINKS[*]}"
sleep 0.5

# Create VSCode settings and keybindings sym-links in Code Path
CODE_SYMLINKS=("settings.json" "keybindings.json")
for name in "${CODE_SYMLINKS[@]}"; do
  target="$CODE_SETTINGS_DIR/$name"
  backupFile $target
  symlink $DOTFILES_DIR/$name $target
done
echo "✅ Created Sym-Links in $CODE_SETTINGS_DIR for: ${CODE_SYMLINKS[*]}"
sleep 0.5

# Create SSH config sym-link in SSH path
target=$SSH_DIR/config
backupFile $target
symlink $DOTFILES_DIR/config $target
echo "✅ Created Sym-Link in $SSH_DIR for: config"
sleep 0.5

mkdir "$HOME/.tmux-sessions"

# Reload shell
exec zsh

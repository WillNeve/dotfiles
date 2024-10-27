# [Oh-My-ZSH Config]
OMZSH_DIR=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
ZSH_DISABLE_COMPFIX=true
plugins=(git gitfast last-working-dir common-aliases zsh-syntax-highlighting history-substring-search ssh-agent)
# Config Execute main Oh My ZSH script
source "${OMZSH_DIR}/oh-my-zsh.sh"

# [Aliases]
# Remove aliases that some plugins bring
unalias rm
unalias lt
# Execute aliases script to import custom aliases
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# [ENV Exports]
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BROWSER='/mnt/c/Program Files(x86)/Google/Chrome/Application/chrome.exe' # Link to Windows 11 Browser Exe
export EDITOR=code
export BUNDLER_EDITOR=code

# [PATH Additions]
export PATH="${PATH}:./bin:./node_modules/.bin:/usr/local/bin:${HOME}/.rbenv/bin"

# [Startup Services] # ? These may not work initially until you have completed setup!
# Initialise Ruby Env
type -a rbenv > /dev/null && eval "$(rbenv init -)"
# Start postgresql local server
sudo /etc/init.d/postgresql start
# Start NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

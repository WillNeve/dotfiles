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
export PATH="${PATH}:./bin:./node_modules/.bin:/usr/local/sbin:${HOME}/.rbenv/bin"

# [Startup Services]
# Start postgresql local server
sudo /etc/init.d/postgresql start
# Initialise Ruby Env
type -a rbenv > /dev/null && eval "$(rbenv init -)"
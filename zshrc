# [Oh-My-ZSH]
OMZSH_DIR=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_DISABLE_COMPFIX=true

plugins=(git gitfast last-working-dir common-aliases zsh-syntax-highlighting history-substring-search ssh-agent)
source "${OMZSH_DIR}/oh-my-zsh.sh"
# Remove aliases that some of the above plugins bring
unalias rm
unalias lt

# [P10K Prompt]
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# [Aliases]
# Source aliases definition script
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# [ENV Exports]
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BROWSER='/mnt/c/Program Files(x86)/Google/Chrome/Application/chrome.exe' # Link to Windows 11 Browser Exe
export EDITOR=code
export BUNDLER_EDITOR=code

# [PATH Entries]
path_entries=(
    /usr/local/bin # user bin
    ./bin # local directory bin
    ./node_modules/.bin # local directory node_modules bin
    $HOME/.tmux-sessions
    $HOME/.rbenv/bin
)
typeset -U PATH path
export PATH="${(j.:.)path_entries}:$PATH"

# [Startup Services] # ? These may not work initially until you have completed setup!
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Initialise Ruby Env
type -a rbenv > /dev/null && eval "$(rbenv init -)"
# Start postgresql local server
sudo /etc/init.d/postgresql start
# Start NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="$FLYCTL_INSTALL/bin:$PATH"
# TEMP
export FLYCTL_INSTALL="/home/willneve/.fly"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

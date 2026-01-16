# Catppuccin Latte theme for Powerlevel10k
# Based on the dark (Macchiato) config, converted to light theme colors
#
# Catppuccin Latte Palette:
#   Base:      #eff1f5   Surface0:  #ccd0da   Surface1:  #bcc0cc
#   Text:      #4c4f69   Subtext0:  #6c6f85   Overlay0:  #9ca0b0
#   Blue:      #1e66f5   Green:     #40a02b   Yellow:    #df8e1d
#   Red:       #d20f39   Teal:      #179299   Sky:       #04a5e5
#   Lavender:  #7287fd   Pink:      #ea76cb   Mauve:     #8839ef

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    dir
    vcs
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status
    command_execution_time
    background_jobs
    direnv
    asdf
    virtualenv
    anaconda
    pyenv
    goenv
    nodenv
    nvm
    nodeenv
    rbenv
    rvm
    fvm
    luaenv
    jenv
    plenv
    perlbrew
    phpenv
    scalaenv
    haskell_stack
    kubecontext
    terraform
    aws
    aws_eb_env
    azure
    gcloud
    google_app_cred
    toolbox
    context
    nordvpn
    ranger
    yazi
    nnn
    lf
    xplr
    vim_shell
    midnight_commander
    nix_shell
    chezmoi_shell
    vi_mode
    todo
    timewarrior
    taskwarrior
    per_directory_history
    time
  )

  typeset -g POWERLEVEL9K_MODE=nerdfont-v3
  typeset -g POWERLEVEL9K_ICON_PADDING=none
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=

  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

  # Multiline prompt ornaments - using Latte Overlay0 for light theme
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%F{#9ca0b0}╭─%f'
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX='%F{#9ca0b0}├─%f'
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%F{#9ca0b0}╰─%f'
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX='%F{#9ca0b0}─╮%f'
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX='%F{#9ca0b0}─┤%f'
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX='%F{#9ca0b0}─╯%f'

  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_GAP_BACKGROUND=
  if [[ $POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR != ' ' ]]; then
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND='#9ca0b0'
    typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%}'
    typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%}'
  fi

  # Default background - Latte Crust
  typeset -g POWERLEVEL9K_BACKGROUND='#dce0e8'

  # Separators - using Latte Text
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='%F{#4c4f69}%B\u2571%b'
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='%F{#4c4f69}%B\u2571%b'
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='\uE0BC'
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='\uE0BA'

  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0BC'
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0BA'
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=

  # OS icon - Latte Text
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='#4c4f69'

  # Prompt char
  typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#40a02b'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#d20f39'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_{LEFT,RIGHT}_WHITESPACE=

  # Directory - Latte Blue
  typeset -g POWERLEVEL9K_DIR_FOREGROUND='#1e66f5'
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#6c6f85'
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='#04a5e5'
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  local anchor_files=(
    .bzr
    .citc
    .git
    .hg
    .node-version
    .python-version
    .go-version
    .ruby-version
    .lua-version
    .java-version
    .perl-version
    .php-version
    .tool-versions
    .mise.toml
    .shorten_folder_marker
    .svn
    .terraform
    CVS
    Cargo.toml
    composer.json
    go.mod
    package.json
    stack.yaml
  )
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"
  typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3

  # VCS (Git)
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\uf126 '
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

  function my_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
      typeset -g my_git_format=$P9K_CONTENT
      return
    fi

    if (( $1 )); then
      # Styling for up-to-date Git status - Latte colors
      local       meta='%F{#9ca0b0}'  # Latte Overlay0
      local      clean='%F{#40a02b}'  # Latte Green
      local   modified='%F{#df8e1d}'  # Latte Yellow
      local  untracked='%F{#1e66f5}'  # Latte Blue
      local conflicted='%F{#d20f39}'  # Latte Red
    else
      # Styling for incomplete and stale Git status
      local       meta='%F{#8c8fa1}'  # Latte Subtext1
      local      clean='%F{#8c8fa1}'
      local   modified='%F{#8c8fa1}'
      local  untracked='%F{#8c8fa1}'
      local conflicted='%F{#8c8fa1}'
    fi

    local res

    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
      (( $#branch > 32 )) && branch[13,-13]="…"
      res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
    fi

    if [[ -n $VCS_STATUS_TAG
          && -z $VCS_STATUS_LOCAL_BRANCH
        ]]; then
      local tag=${(V)VCS_STATUS_TAG}
      (( $#tag > 32 )) && tag[13,-13]="…"
      res+="${meta}#${clean}${tag//\%/%%}"
    fi

    [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] &&
      res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"

    if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
      res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"
    fi

    if [[ $VCS_STATUS_COMMIT_SUMMARY == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]]; then
      res+=" ${modified}wip"
    fi

    if (( VCS_STATUS_COMMITS_AHEAD || VCS_STATUS_COMMITS_BEHIND )); then
      (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
      (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
      (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
    fi

    (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
    (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
    (( VCS_STATUS_STASHES        )) && res+=" ${clean}*${VCS_STATUS_STASHES}"
    [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
    (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
    (( VCS_STATUS_NUM_STAGED     )) && res+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
    (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
    (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
    (( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"

    typeset -g my_git_format=$res
  }
  functions -M my_git_formatter 2>/dev/null

  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
  typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter(0)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1

  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR='#40a02b'
  typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR='#8c8fa1'

  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#40a02b'
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#40a02b'
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#df8e1d'

  # Status
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true

  typeset -g POWERLEVEL9K_STATUS_OK=true
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND='#40a02b'
  typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'

  typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND='#40a02b'
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='✔'

  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#d20f39'
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'

  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND='#d20f39'
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='✘'

  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND='#d20f39'
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='✘'

  # Command execution time
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#6c6f85'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

  # Background jobs
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='#179299'

  # Direnv
  typeset -g POWERLEVEL9K_DIRENV_FOREGROUND='#df8e1d'

  # ASDF
  typeset -g POWERLEVEL9K_ASDF_FOREGROUND='#7287fd'
  typeset -g POWERLEVEL9K_ASDF_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_ASDF_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_ASDF_SHOW_SYSTEM=true
  typeset -g POWERLEVEL9K_ASDF_SHOW_ON_UPGLOB=

  typeset -g POWERLEVEL9K_ASDF_RUBY_FOREGROUND='#ea76cb'
  typeset -g POWERLEVEL9K_ASDF_PYTHON_FOREGROUND='#179299'
  typeset -g POWERLEVEL9K_ASDF_GOLANG_FOREGROUND='#179299'
  typeset -g POWERLEVEL9K_ASDF_NODEJS_FOREGROUND='#40a02b'
  typeset -g POWERLEVEL9K_ASDF_RUST_FOREGROUND='#179299'
  typeset -g POWERLEVEL9K_ASDF_DOTNET_CORE_FOREGROUND='#8839ef'
  typeset -g POWERLEVEL9K_ASDF_FLUTTER_FOREGROUND='#04a5e5'
  typeset -g POWERLEVEL9K_ASDF_LUA_FOREGROUND='#1e66f5'
  typeset -g POWERLEVEL9K_ASDF_JAVA_FOREGROUND='#1e66f5'
  typeset -g POWERLEVEL9K_ASDF_PERL_FOREGROUND='#7287fd'
  typeset -g POWERLEVEL9K_ASDF_ERLANG_FOREGROUND='#e64553'
  typeset -g POWERLEVEL9K_ASDF_ELIXIR_FOREGROUND='#8839ef'
  typeset -g POWERLEVEL9K_ASDF_POSTGRES_FOREGROUND='#1e66f5'
  typeset -g POWERLEVEL9K_ASDF_PHP_FOREGROUND='#8839ef'
  typeset -g POWERLEVEL9K_ASDF_HASKELL_FOREGROUND='#df8e1d'
  typeset -g POWERLEVEL9K_ASDF_JULIA_FOREGROUND='#40a02b'

  # NordVPN
  typeset -g POWERLEVEL9K_NORDVPN_FOREGROUND='#04a5e5'
  typeset -g POWERLEVEL9K_NORDVPN_{DISCONNECTED,CONNECTING,DISCONNECTING}_CONTENT_EXPANSION=
  typeset -g POWERLEVEL9K_NORDVPN_{DISCONNECTED,CONNECTING,DISCONNECTING}_VISUAL_IDENTIFIER_EXPANSION=

  # Ranger
  typeset -g POWERLEVEL9K_RANGER_FOREGROUND='#df8e1d'
  
  # Yazi
  typeset -g POWERLEVEL9K_YAZI_FOREGROUND='#df8e1d'

  # nnn
  typeset -g POWERLEVEL9K_NNN_FOREGROUND='#179299'

  # lf
  typeset -g POWERLEVEL9K_LF_FOREGROUND='#179299'

  # xplr
  typeset -g POWERLEVEL9K_XPLR_FOREGROUND='#179299'

  # Vim shell
  typeset -g POWERLEVEL9K_VIM_SHELL_FOREGROUND='#40a02b'

  # Midnight Commander
  typeset -g POWERLEVEL9K_MIDNIGHT_COMMANDER_FOREGROUND='#df8e1d'

  # Nix shell
  typeset -g POWERLEVEL9K_NIX_SHELL_FOREGROUND='#7287fd'

  # Chezmoi shell
  typeset -g POWERLEVEL9K_CHEZMOI_SHELL_FOREGROUND='#1e66f5'

  # Disk usage
  typeset -g POWERLEVEL9K_DISK_USAGE_NORMAL_FOREGROUND='#40a02b'
  typeset -g POWERLEVEL9K_DISK_USAGE_WARNING_FOREGROUND='#df8e1d'
  typeset -g POWERLEVEL9K_DISK_USAGE_CRITICAL_FOREGROUND='#d20f39'
  typeset -g POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL=90
  typeset -g POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL=95
  typeset -g POWERLEVEL9K_DISK_USAGE_ONLY_WARNING=false

  # Vi mode
  typeset -g POWERLEVEL9K_VI_COMMAND_MODE_STRING=NORMAL
  typeset -g POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND='#40a02b'
  typeset -g POWERLEVEL9K_VI_VISUAL_MODE_STRING=VISUAL
  typeset -g POWERLEVEL9K_VI_MODE_VISUAL_FOREGROUND='#7287fd'
  typeset -g POWERLEVEL9K_VI_OVERWRITE_MODE_STRING=OVERTYPE
  typeset -g POWERLEVEL9K_VI_MODE_OVERWRITE_FOREGROUND='#df8e1d'
  typeset -g POWERLEVEL9K_VI_INSERT_MODE_STRING=
  typeset -g POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND='#7287fd'

  # RAM
  typeset -g POWERLEVEL9K_RAM_FOREGROUND='#7287fd'

  # Swap
  typeset -g POWERLEVEL9K_SWAP_FOREGROUND='#8839ef'

  # Load
  typeset -g POWERLEVEL9K_LOAD_WHICH=5
  typeset -g POWERLEVEL9K_LOAD_NORMAL_FOREGROUND='#7287fd'
  typeset -g POWERLEVEL9K_LOAD_WARNING_FOREGROUND='#df8e1d'
  typeset -g POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND='#fe640b'

  # Todo
  typeset -g POWERLEVEL9K_TODO_FOREGROUND='#7287fd'
  typeset -g POWERLEVEL9K_TODO_HIDE_ZERO_TOTAL=true
  typeset -g POWERLEVEL9K_TODO_HIDE_ZERO_FILTERED=false

  # Timewarrior
  typeset -g POWERLEVEL9K_TIMEWARRIOR_FOREGROUND='#7287fd'
  typeset -g POWERLEVEL9K_TIMEWARRIOR_CONTENT_EXPANSION='${P9K_CONTENT:0:24}${${P9K_CONTENT:24}:+…}'

  # Taskwarrior
  typeset -g POWERLEVEL9K_TASKWARRIOR_FOREGROUND='#7287fd'

  # Per-directory history
  typeset -g POWERLEVEL9K_PER_DIRECTORY_HISTORY_LOCAL_FOREGROUND='#8839ef'
  typeset -g POWERLEVEL9K_PER_DIRECTORY_HISTORY_GLOBAL_FOREGROUND='#df8e1d'

  # CPU architecture
  typeset -g POWERLEVEL9K_CPU_ARCH_FOREGROUND='#df8e1d'

  # Context
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='#df8e1d'
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND='#6c6f85'
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND='#6c6f85'
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%B%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=

  # Virtualenv
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#179299'
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false
  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=

  # Anaconda
  typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND='#179299'
  typeset -g POWERLEVEL9K_ANACONDA_CONTENT_EXPANSION='${${${${CONDA_PROMPT_MODIFIER#\(}% }%\)}:-${CONDA_PREFIX:t}}'

  # Pyenv
  typeset -g POWERLEVEL9K_PYENV_FOREGROUND='#179299'
  typeset -g POWERLEVEL9K_PYENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_PYENV_SHOW_SYSTEM=true
  typeset -g POWERLEVEL9K_PYENV_CONTENT_EXPANSION='${P9K_CONTENT}${${P9K_CONTENT:#$P9K_PYENV_PYTHON_VERSION(|/*)}:+ $P9K_PYENV_PYTHON_VERSION}'

  # Goenv
  typeset -g POWERLEVEL9K_GOENV_FOREGROUND='#179299'
  typeset -g POWERLEVEL9K_GOENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_GOENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_GOENV_SHOW_SYSTEM=true

  # Nodenv
  typeset -g POWERLEVEL9K_NODENV_FOREGROUND='#40a02b'
  typeset -g POWERLEVEL9K_NODENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_NODENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_NODENV_SHOW_SYSTEM=true

  # NVM
  typeset -g POWERLEVEL9K_NVM_FOREGROUND='#40a02b'
  typeset -g POWERLEVEL9K_NVM_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_NVM_SHOW_SYSTEM=true

  # Nodeenv
  typeset -g POWERLEVEL9K_NODEENV_FOREGROUND='#40a02b'
  typeset -g POWERLEVEL9K_NODEENV_SHOW_NODE_VERSION=false
  typeset -g POWERLEVEL9K_NODEENV_{LEFT,RIGHT}_DELIMITER=

  # Node version
  typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND='#40a02b'
  typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true

  # Go version
  typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND='#179299'
  typeset -g POWERLEVEL9K_GO_VERSION_PROJECT_ONLY=true

  # Rust version
  typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND='#179299'
  typeset -g POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY=true

  # .NET version
  typeset -g POWERLEVEL9K_DOTNET_VERSION_FOREGROUND='#8839ef'
  typeset -g POWERLEVEL9K_DOTNET_VERSION_PROJECT_ONLY=true

  # PHP version
  typeset -g POWERLEVEL9K_PHP_VERSION_FOREGROUND='#8839ef'
  typeset -g POWERLEVEL9K_PHP_VERSION_PROJECT_ONLY=true

  # Laravel version
  typeset -g POWERLEVEL9K_LARAVEL_VERSION_FOREGROUND='#d20f39'

  # Java version
  typeset -g POWERLEVEL9K_JAVA_VERSION_FOREGROUND='#1e66f5'
  typeset -g POWERLEVEL9K_JAVA_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_JAVA_VERSION_FULL=false

  # Package
  typeset -g POWERLEVEL9K_PACKAGE_FOREGROUND='#7287fd'

  # Rbenv
  typeset -g POWERLEVEL9K_RBENV_FOREGROUND='#ea76cb'
  typeset -g POWERLEVEL9K_RBENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_RBENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_RBENV_SHOW_SYSTEM=true

  # RVM
  typeset -g POWERLEVEL9K_RVM_FOREGROUND='#ea76cb'
  typeset -g POWERLEVEL9K_RVM_SHOW_GEMSET=false
  typeset -g POWERLEVEL9K_RVM_SHOW_PREFIX=false

  # FVM
  typeset -g POWERLEVEL9K_FVM_FOREGROUND='#04a5e5'

  # Luaenv
  typeset -g POWERLEVEL9K_LUAENV_FOREGROUND='#1e66f5'
  typeset -g POWERLEVEL9K_LUAENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_LUAENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_LUAENV_SHOW_SYSTEM=true

  # Jenv
  typeset -g POWERLEVEL9K_JENV_FOREGROUND='#1e66f5'
  typeset -g POWERLEVEL9K_JENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_JENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_JENV_SHOW_SYSTEM=true

  # Plenv
  typeset -g POWERLEVEL9K_PLENV_FOREGROUND='#7287fd'
  typeset -g POWERLEVEL9K_PLENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_PLENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_PLENV_SHOW_SYSTEM=true

  # Perlbrew
  typeset -g POWERLEVEL9K_PERLBREW_FOREGROUND='#7287fd'
  typeset -g POWERLEVEL9K_PERLBREW_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_PERLBREW_SHOW_PREFIX=false

  # Phpenv
  typeset -g POWERLEVEL9K_PHPENV_FOREGROUND='#8839ef'
  typeset -g POWERLEVEL9K_PHPENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_PHPENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_PHPENV_SHOW_SYSTEM=true

  # Scalaenv
  typeset -g POWERLEVEL9K_SCALAENV_FOREGROUND='#d20f39'
  typeset -g POWERLEVEL9K_SCALAENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_SCALAENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_SCALAENV_SHOW_SYSTEM=true

  # Haskell stack
  typeset -g POWERLEVEL9K_HASKELL_STACK_FOREGROUND='#df8e1d'
  typeset -g POWERLEVEL9K_HASKELL_STACK_SOURCES=(shell local)
  typeset -g POWERLEVEL9K_HASKELL_STACK_ALWAYS_SHOW=true

  # Terraform
  typeset -g POWERLEVEL9K_TERRAFORM_SHOW_DEFAULT=false
  typeset -g POWERLEVEL9K_TERRAFORM_CLASSES=(
      '*'         OTHER)
  typeset -g POWERLEVEL9K_TERRAFORM_OTHER_FOREGROUND='#04a5e5'

  # Terraform version
  typeset -g POWERLEVEL9K_TERRAFORM_VERSION_FOREGROUND='#04a5e5'

  # Kubecontext
  typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|flux|fluxctl|stern|kubeseal|skaffold|kubent|kubecolor|cmctl|sparkctl'
  typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
      '*'       DEFAULT)
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND='#8839ef'
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION=
  POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${P9K_KUBECONTEXT_CLOUD_CLUSTER:-${P9K_KUBECONTEXT_NAME}}'
  POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${${:-/$P9K_KUBECONTEXT_NAMESPACE}:#/default}'

  # AWS
  typeset -g POWERLEVEL9K_AWS_SHOW_ON_COMMAND='aws|awless|cdk|terraform|pulumi|terragrunt'
  typeset -g POWERLEVEL9K_AWS_CLASSES=(
      '*'       DEFAULT)
  typeset -g POWERLEVEL9K_AWS_DEFAULT_FOREGROUND='#fe640b'
  typeset -g POWERLEVEL9K_AWS_CONTENT_EXPANSION='${P9K_AWS_PROFILE//\%/%%}${P9K_AWS_REGION:+ ${P9K_AWS_REGION//\%/%%}}'

  # AWS EB
  typeset -g POWERLEVEL9K_AWS_EB_ENV_FOREGROUND='#40a02b'

  # Azure
  typeset -g POWERLEVEL9K_AZURE_SHOW_ON_COMMAND='az|terraform|pulumi|terragrunt'
  typeset -g POWERLEVEL9K_AZURE_CLASSES=(
      '*'         OTHER)
  typeset -g POWERLEVEL9K_AZURE_OTHER_FOREGROUND='#1e66f5'

  # Google Cloud
  typeset -g POWERLEVEL9K_GCLOUD_SHOW_ON_COMMAND='gcloud|gcs|gsutil'
  typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND='#1e66f5'
  typeset -g POWERLEVEL9K_GCLOUD_PARTIAL_CONTENT_EXPANSION='${P9K_GCLOUD_PROJECT_ID//\%/%%}'
  typeset -g POWERLEVEL9K_GCLOUD_COMPLETE_CONTENT_EXPANSION='${P9K_GCLOUD_PROJECT_NAME//\%/%%}'
  typeset -g POWERLEVEL9K_GCLOUD_REFRESH_PROJECT_NAME_SECONDS=60

  # Google App Credentials
  typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_SHOW_ON_COMMAND='terraform|pulumi|terragrunt'
  typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_CLASSES=(
      '*'             DEFAULT)
  typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_FOREGROUND='#1e66f5'
  typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_CONTENT_EXPANSION='${P9K_GOOGLE_APP_CRED_PROJECT_ID//\%/%%}'

  # Toolbox
  typeset -g POWERLEVEL9K_TOOLBOX_FOREGROUND='#df8e1d'
  typeset -g POWERLEVEL9K_TOOLBOX_CONTENT_EXPANSION='${P9K_TOOLBOX_NAME:#fedora-toolbox-*}'

  # Public IP
  typeset -g POWERLEVEL9K_PUBLIC_IP_FOREGROUND='#6c6f85'

  # VPN IP
  typeset -g POWERLEVEL9K_VPN_IP_FOREGROUND='#04a5e5'
  typeset -g POWERLEVEL9K_VPN_IP_CONTENT_EXPANSION=
  typeset -g POWERLEVEL9K_VPN_IP_INTERFACE='(gpd|wg|(.*tun)|tailscale)[0-9]*|(zt.*)'
  typeset -g POWERLEVEL9K_VPN_IP_SHOW_ALL=false

  # IP
  typeset -g POWERLEVEL9K_IP_FOREGROUND='#04a5e5'
  typeset -g POWERLEVEL9K_IP_CONTENT_EXPANSION='${P9K_IP_RX_RATE:+%F{#40a02b}⇣$P9K_IP_RX_RATE }${P9K_IP_TX_RATE:+%F{#fe640b}⇡$P9K_IP_TX_RATE }%F{#04a5e5}$P9K_IP_IP'
  typeset -g POWERLEVEL9K_IP_INTERFACE='[ew].*'

  # Proxy
  typeset -g POWERLEVEL9K_PROXY_FOREGROUND='#7287fd'

  # Battery
  typeset -g POWERLEVEL9K_BATTERY_LOW_THRESHOLD=20
  typeset -g POWERLEVEL9K_BATTERY_LOW_FOREGROUND='#d20f39'
  typeset -g POWERLEVEL9K_BATTERY_{CHARGING,CHARGED}_FOREGROUND='#40a02b'
  typeset -g POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND='#df8e1d'
  typeset -g POWERLEVEL9K_BATTERY_STAGES='\UF008E\UF007A\UF007B\UF007C\UF007D\UF007E\UF007F\UF0080\UF0081\UF0082\UF0079'
  typeset -g POWERLEVEL9K_BATTERY_VERBOSE=false

  # WiFi
  typeset -g POWERLEVEL9K_WIFI_FOREGROUND='#7287fd'

  # Time
  typeset -g POWERLEVEL9K_TIME_FOREGROUND='#7287fd'
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false

  # Example segment
  function prompt_example() {
    p10k segment -f '#fe640b' -i '⭐' -t 'hello, %n'
  }

  function instant_prompt_example() {
    prompt_example
  }

  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  (( ! $+functions[p10k] )) || p10k reload
}

typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'

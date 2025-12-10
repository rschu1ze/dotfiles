# Called by bash interactive shells

export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias c='clear'
alias e='exit'
alias g='git'
alias p='python3'
alias v='nvim'
alias s='ssh'
alias t='tmux'
alias d='docker'
# exa is unmaintained on MacOS https://formulae.brew.sh/formula/exa
if [ "$(uname)" != "Darwin" ]; then
    alias ls='exa --group-directories-first --classify'
    alias la='exa --group-directories-first --classify --all' # 'ls -A'
    alias ll='exa --long --group-directories-first --classify --all' # 'ls -alF'
    alias less='batcat'
fi
alias diff='diff --color -u'
alias chs='./clickhouse-server'
alias chc='./clickhouse-client'

if [ -x "$(command -v /opt/homebrew/bin/brew)" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export EDITOR='nvim'

# This achieves 24-bit true colors.
# Test with https://unix.stackexchange.com/questions/404414/print-true-color-24-bit-test-pattern
export TERM=xterm-256color

# History stuff (not on macOS ... their bash is too old)
if [ "$(uname)" != "Darwin" ]; then
    export HISTSIZE=-1 # unlimited in-memory history size
    export HISTFILESIZE=-1 # unlimited on-disk history file size
    export HISTCONTROL=ignoreboth:erasedups
    # Nice but not practical:
    # shopt -s histappend # append to history file
    # PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND" # append to / read from history file for each command
fi

export BASH_SILENCE_DEPRECATION_WARNING=1 # macOS: Suppress warning "The default interactive shell is now zsh."

# Support XDG base directory spec in tools
export XDG_CONFIG_HOME=$HOME/.config
export INPUTRC=$XDG_CONFIG_HOME/readline/inputrc
export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgrep/config

extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       rar x $1       ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.zst)       unzstd $1      ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi
}

# -- ClickHouse-specific stuff --------------------------------------------------------------

if [ -x "$(command -v /opt/homebrew/bin/brew)" ]; then
    # MacOS: prefer Clang from Homebrew over Apple's Clang
    export PATH=$(brew --prefix llvm)/bin:$PATH
    export CC=$(brew --prefix llvm)/bin/clang
    export CXX=$(brew --prefix llvm)/bin/clang++
else
    # Linux:
    export CC=clang-19
    export CXX=clang++-19
    export CORES=$(nproc)
fi

# CHCACHE="/data/chcache/chcache-rust/target/release/chcache-rust"
# CH_COMMON="-DCMAKE_CXX_COMPILER_LAUNCHER=${CHCACHE} -DCMAKE_C_COMPILER_LAUNCHER=${CHCACHE} -DCOMPILER_CACHE=disabled -DPARALLEL_COMPILE_JOBS=${CORES} -DPARALLEL_LINK_JOBS=${CORES} -DENABLE_BUILD_PATH_MAPPING=0 -S . -B build"
CH_COMMON="-DPARALLEL_COMPILE_JOBS=${CORES} -DPARALLEL_LINK_JOBS=${CORES} -DENABLE_BUILD_PATH_MAPPING=0 -DENABLE_TESTS=0 -S . -B build"

CH_LITE="-DENABLE_LIBRARIES=0 -DENABLE_LIBURING=1"
CH_FULL="-DENABLE_LIBRARIES=1"
CH_DBG="-DCMAKE_BUILD_TYPE=Debug -DDEBUG_O_LEVEL=0"
CH_REL="-DCMAKE_BUILD_TYPE=RelWithDebInfo -DENABLE_THINLTO=0"
CH_NONE="-DCMAKE_BUILD_TYPE=None"

alias make_dbg_lite="cmake ${CH_LITE} ${CH_DBG}  ${CH_COMMON}"
alias make_rel_lite="cmake ${CH_LITE} ${CH_REL}  ${CH_COMMON}"
alias make_dbg_full="cmake  ${CH_FULL}  ${CH_DBG}  ${CH_COMMON}"
alias make_rel_full="cmake  ${CH_FULL}  ${CH_REL}  ${CH_COMMON}"
alias make_tsan="cmake     ${CH_FULL}  ${CH_NONE} ${CH_COMMON} -DSANITIZE=thread"
alias make_ubsan="cmake    ${CH_FULL}  ${CH_NONE} ${CH_COMMON} -DSANITIZE=undefined"
alias make_msan="cmake     ${CH_FULL}  ${CH_NONE} ${CH_COMMON} -DSANITIZE=memory"
alias make_asan="cmake     ${CH_FULL}  ${CH_NONE} ${CH_COMMON} -DSANITIZE=address"
alias cbuild="cmake --build build --parallel -- "

# -------------------------------------------------------------------------------------------

# Make $__git_ps1 available, https://stackoverflow.com/a/15398153
if [[ ! -f ~/.git-prompt.sh ]]
then
    curl -L https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh > ~/.git-prompt.sh
fi
source ~/.git-prompt.sh

# Git autocompletion for Bash, https://stackoverflow.com/a/19876372
if [[ ! -f ~/.git-completion.bash ]]
then
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/.git-completion.bash
fi
source ~/.git-completion.bash

# Make Git completion work with g alias, https://askubuntu.com/a/642778
__git_complete g __git_main

# In order to make this fast enough ignore submodules in large repos. Change in .git-prompt.sh
#      git diff --no-ext-diff --quiet || w="*"
#      git diff --no-ext-diff --cached --quiet || i="+"
# to
#      git diff --no-ext-diff --quiet -- :!contrib || w="*"
#      git diff --no-ext-diff --cached --quiet -- :!contrib || i="+"
# (search for GIT_PS1_SHOWDIRTYSTATE)
# See
# - https://seb.jambor.dev/posts/performance-optimizations-for-the-shell-prompt/
# - https://css-tricks.com/git-pathspecs-and-how-to-use-them/
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM='auto'
export PS1='\n\w$(__git_ps1 " (%s)") \$ '

alias rgc='rg -tcpp' # ripgrep for cpp files

# Install fzf: https://github.com/junegunn/fzf, useful for kubectx and kubens
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

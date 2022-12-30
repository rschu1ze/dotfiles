# Called by bash interactive shells

export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias e='exit'
alias g='git'
alias py='python'
alias v='nvim'
alias t='tmux'
alias ll='ls -alF'
alias la='ls -A'

export CH_CORES_FOR_COMPILATION=$(nproc --all)

if [ -x "$(command -v /opt/homebrew/bin/brew)" ]; then
    # MacOS: prefer Clang from Homebrew over Apple's Clang
    export PATH=$(brew --prefix llvm)/bin:$PATH
    export CC=$(brew --prefix llvm)/bin/clang
    export CXX=$(brew --prefix llvm)/bin/clang++
    export WITH_LIBUNWIND=""
else
    # Linux:
    export CC=clang
    export CXX=clang++
    # on Ubuntu 22.04, if internal libunwind is disabled (i.e. the standard exception handler is used), the linker complains:
    #     ld.lld-14: error: unable to find library -lgcc_eh
    export WITH_LIBUNWIND="-DUSE_UNWIND=1" # force internal libunwind
fi

# CH_SHARED_LIBS="-DUSE_STATIC_LIBRARIES=0 -DSPLIT_SHARED_LIBRARIES=1"
CH_SHARED_LIBS=""

CH_COMMON_BUILD_OPTIONS="${WITH_LIBUNWIND} ${CH_SHARED_LIBS}"

CH_SLIM_BUILD_OPTIONS="-DENABLE_EMBEDDED_COMPILER=0 -DENABLE_LIBRARIES=0"
CH_FAT_BUILD_OPTIONS="-DENABLE_EMBEDDED_COMPILER=1 -DENABLE_LIBRARIES=1"

CH_BUILD_TYPE_DEBUG="-DCMAKE_BUILD_TYPE=Debug"
CH_BUILD_TYPE_RELWITHDEBINFO="-DCMAKE_BUILD_TYPE=RelWithDebInfo"

CH_PATH_TO_SOURCE_AND_BUILD="-S . -B build"

alias make_dbg_slim="cmake ${CH_COMMON_BUILD_OPTIONS} ${CH_SLIM_BUILD_OPTIONS} ${CH_BUILD_TYPE_DEBUG}          ${CH_PATH_TO_SOURCE_AND_BUILD}"
alias make_rel_slim="cmake ${CH_COMMON_BUILD_OPTIONS} ${CH_SLIM_BUILD_OPTIONS} ${CH_BUILD_TYPE_RELWITHDEBINFO} ${CH_PATH_TO_SOURCE_AND_BUILD}"
alias make_dbg_fat="cmake  ${CH_COMMON_BUILD_OPTIONS} ${CH_FAT_BUILD_OPTIONS}  ${CH_BUILD_TYPE_DEBUG}          ${CH_PATH_TO_SOURCE_AND_BUILD}"
alias make_rel_fat="cmake  ${CH_COMMON_BUILD_OPTIONS} ${CH_FAT_BUILD_OPTIONS}  ${CH_BUILD_TYPE_RELWITHDEBINFO} ${CH_PATH_TO_SOURCE_AND_BUILD}"

alias cbuild="cmake --build build -j${CH_CORES_FOR_COMPILATION} -- "

export EDITOR='nvim'

# Seems not needed on Mac, already set by terminal emulator, check with 'echo $TERM'
# It is not recommended to set the terminal in the shell profile, cf. https://jdhao.github.io/2018/10/19/tmux_nvim_true_color/
#export TERM=xterm-256color

export HISTSIZE=1000000
export HISTFILESIZE=1000000000
export HISTCONTROL=ignoreboth:erasedups

# suppress annoying warning "The default interactive shell is now zsh."
export BASH_SILENCE_DEPRECATION_WARNING=1

# EXTRACT FUNCTION ## | Usage: extract <file>
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
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi
}

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

# In order to make this fast enough ignore submodules in large repos. Change in .git-prompt
#      git diff --no-ext-diff --quiet || w="*"
#      git diff --no-ext-diff --cached --quiet || i="+"
# to
#      git diff --no-ext-diff --quiet -- :/src || w="*"
#      git diff --no-ext-diff --cached --quiet -- :/src || i="+"
# (search for GIT_PS1_SHOWDIRTYSTATE)
# See https://seb.jambor.dev/posts/performance-optimizations-for-the-shell-prompt/
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM='auto'
export PS1='\n\w$(__git_ps1 " (%s)") \$ '

# Some Git commands should only be available via an alias (e.g. 'git p' instead of 'git push') because the alias is shorter or allows to
# pass some options as command line parameters which cannot be set in Git's configuration. Unfortunately, Git does not allow an alias to
# have the same name as the command. As a workaround, forbid some git commands and enforce usage of an alias with a different name.
# (https://stackoverflow.com/a/39357426)
function git {
    if [[ "$1" == "fetch" && "$@" != *"--help"* ]]; then
        use_the_alias_instead
    elif [[ "$1" == "fuckit" && "$@" != *"--help"* ]]; then
        use_the_alias_instead
    elif [[ "$1" == "push" && "$@" != *"--help"* ]]; then
        use_the_alias_instead
    elif [[ "$1" == "pull" && "$@" != *"--help"* ]]; then
        use_the_alias_instead
    elif [[ "$1" == "push" && "$@" != *"--help"* ]]; then
        use_the_alias_instead
    elif [[ "$1" == "remote" && "$@" != *"--help"* ]]; then
        use_the_alias_instead
    elif [[ "$1" == "show" && "$@" != *"--help"* ]]; then
        use_the_alias_instead
    elif [[ "$1" == "status" && "$@" != *"--help"* ]]; then
        use_the_alias_instead
    elif [[ "$1" == "submodule" && "$@" != *"--help"* ]]; then
        use_the_alias_instead
    else
        command git "$@"
    fi
}

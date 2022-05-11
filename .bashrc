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

CH_GENERATOR="-GNinja"

if [ -x "$(command -v /opt/homebrew/bin/brew)" ]; then
    # MacOS
    CH_TOOLS="-DCMAKE_C_COMPILER=$(brew --prefix llvm)/bin/clang -DCMAKE_CXX_COMPILER=$(brew --prefix llvm)/bin/clang++ -DCMAKE_AR=$(brew --prefix llvm)/bin/llvm-ar -DCMAKE_RANLIB=$(brew --prefix llvm)/bin/llvm-ranlib -DOBJCOPY_PATH=$(brew --prefix llvm)/bin/llvm-objcopy"
else
    # Linux
    CH_TOOLS=""
fi

CH_SLIM_BUILD_OPTIONS="-DENABLE_S3=0 -DENABLE_AVRO=0 -DENABLE_EMBEDDED_COMPILER=0 -DENABLE_GRPC=0 -DENABLE_PARQUET=0 -DENABLE_ROCKSDB=0 -DENABLE_MYSQL=0 -DENABLE_KAFKA=0 -DENABLE_PROTOBUF=0"
CH_FAT_BUILD_OPTIONS="-DENABLE_S3=1 -DENABLE_AVRO=1 -DENABLE_EMBEDDED_COMPILER=1 -DENABLE_GRPC=1 -DENABLE_PARQUET=1 -DENABLE_ROCKSDB=1 -DENABLE_MYSQL=1 -DENABLE_KAFKA=1 -DENABLE_PROTOBUF=1"

CH_BUILD_TYPE_DEBUG="-DCMAKE_BUILD_TYPE=Debug"
CH_BUILD_TYPE_RELWITHDEBINFO="-DCMAKE_BUILD_TYPE=RelWithDebInfo"

CH_PATH_TO_SOURCE="-S ."
CH_PATH_TO_BUILD="-B build"

alias make_dbg_slim="cmake ${CH_GENERATOR} ${CH_TOOLS} ${CH_SLIM_BUILD_OPTIONS} ${CMAKE_BUILD_TYPE_SLIM} ${CH_PATH_TO_SOURCE} ${CH_PATH_TO_BUILD}"

alias make_rel_with_dbg_slim="cmake ${CH_GENERATOR} ${CH_TOOLS} ${CH_SLIM_BUILD_OPTIONS} ${CMAKE_BUILD_TYPE_SLIM} ${CH_PATH_TO_SOURCE} ${CH_PATH_TO_BUILD}"

alias make_dbg_fat="cmake ${CH_GENERATOR} ${CH_TOOLS} ${CH_FAT_BUILD_OPTIONS} ${CH_BUILD_TYPE_RELWITHDEBINFO} ${CH_PATH_TO_SOURCE} ${CH_PATH_TO_BUILD}"

alias make_rel_with_dbg_fat="cmake ${CH_GENERATOR} ${CH_TOOLS} ${CH_FAT_BUILD_OPTIONS} ${CH_BUILD_TYPE_RELWITHDEBINFO} ${CH_PATH_TO_SOURCE} ${CH_PATH_TO_BUILD}"

alias cbuild="cmake --build build -- -j10"

# CCache's man page does not explicitly mention XDG config dir support --> force it to read from a sensible location. Verify with
#   ccache --show-stats --verbose
export CCACHE_CONFIGPATH=~/.config/ccache/ccache.conf

export EDITOR='nvim'

# Make neovim installed from https://github.com/neovim/neovim/releases available
export PATH=$PATH:/home/ubuntu/nvim-linux64/bin

# In order to make this fast enough ignore submodules in large repos. Change in .bash-git
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

# Seems not needed on Mac, already set by terminal emulator, check with 'echo $TERM'
# It is not recommended to set the terminal in the shell profile, cf. https://jdhao.github.io/2018/10/19/tmux_nvim_true_color/
#export TERM=xterm-256color

export HISTSIZE=1000000
export HISTFILESIZE=1000000000
export HISTCONTROL=ignoreboth:erasedups

# suppress annoying warning "The default interactive shell is now zsh."
export BASH_SILENCE_DEPRECATION_WARNING=1

# Make ncurses send Escape immediately instead of waiting
# for a multi-character sequence. Useful for neomutt keybinding of Esc as abort key.
export ESCDELAY=0

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

# Some Git commands should only be available via an alias (e.g. 'git p' instead of 'git push') because the alias is shorter or allows to
# pass some options as command line parameters which cannot be set in Git's configuration. Unfortunately, Git does not allow an alias to
# have the same name as the command. As a workaround, forbid some git commands and enforce usage of an alias with a different name.
# (https://stackoverflow.com/a/39357426)
function git {
    if [[ "$1" == "fetch" && "$@" != *"--help"* ]]; then
        use_the_alias_instead
    elif [[ "$1" == "push" && "$@" != *"--help"* ]]; then
        use_the_alias_instead
    elif [[ "$1" == "pull" && "$@" != *"--help"* ]]; then
        use_the_alias_instead
    elif [[ "$1" == "push" && "$@" != *"--help"* ]]; then
        use_the_alias_instead
    elif [[ "$1" == "show" && "$@" != *"--help"* ]]; then
        use_the_alias_instead
    elif [[ "$1" == "status" && "$@" != *"--help"* ]]; then
        use_the_alias_instead
    else
        command git "$@"
    fi
}

# Make $__git_ps1 available, https://stackoverflow.com/a/15398153
source ~/.bash_git

# Git autocompletion for Bash, https://stackoverflow.com/a/19876372
source ~/.git-completion.bash

# Make Git completion work with g alias, https://askubuntu.com/a/642778
__git_complete g __git_main

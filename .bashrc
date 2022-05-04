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
alias m='neomutt'
alias py='python'
alias v='nvim'
alias t='tmux'

alias make_dbg='cmake -GNinja -DCMAKE_C_COMPILER=$(brew --prefix llvm)/bin/clang -DCMAKE_CXX_COMPILER=$(brew --prefix llvm)/bin/clang++ -DCMAKE_AR=$(brew --prefix llvm)/bin/llvm-ar -DCMAKE_RANLIB=$(brew --prefix llvm)/bin/llvm-ranlib -DOBJCOPY_PATH=$(brew --prefix llvm)/bin/llvm-objcopy -DCMAKE_BUILD_TYPE=Debug ..'
alias make_rel_with_dbg='cmake -GNinja -DCMAKE_C_COMPILER=$(brew --prefix llvm)/bin/clang -DCMAKE_CXX_COMPILER=$(brew --prefix llvm)/bin/clang++ -DCMAKE_AR=$(brew --prefix llvm)/bin/llvm-ar -DCMAKE_RANLIB=$(brew --prefix llvm)/bin/llvm-ranlib -DOBJCOPY_PATH=$(brew --prefix llvm)/bin/llvm-objcopy -DCMAKE_BUILD_TYPE=RelWithDebInfo ..'

# On Mac, XDG_CONFIG_HOME isn't set. Unless we tell ccache the
# location of it's config file, it won't pick it up from the
# standard location. On Linux, this environment variable can be
# removed. Verify with ccache --show-stats --verbose
export CCACHE_CONFIGPATH=~/.config/ccache/ccache.conf

export EDITOR='nvim'

# TODO does not seem to work properly?
GIT_PS1_SHOWCOLORHINTS=true
# GIT_PS1_SHOWDIRTYSTATE=true # too slow ...
# GIT_PS1_SHOWSTASHSTATE=true # # fast enough but disabled for consistency with SHOWDIRTYSTATE
# GIT_PS1_SHOWUNTRACKEDFILES=true # fast enough but disabled for consistency with SHOWDIRTYSTATE
export PS1='\n\w$(__git_ps1 " (%s)") \$ '

# Seems not needed on Mac, already set by terminal emulator, check with 'echo $TERM'
# It is not recommended to set the terminal in the shell profile, cf. https://jdhao.github.io/2018/10/19/tmux_nvim_true_color/
#export TERM=xterm-256color

export HISTSIZE=1000000
export HISTFILESIZE=1000000000
export HISTCONTROL=ignoreboth:erasedups

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

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias e='exit'
alias g='LC_ALL=en_US git' # localization is unneeded
alias m='LC_ALL=en_US neomutt'
alias py='python'
alias v='nvim'
alias t='/opt/homebrew/bin/tmux'

export EDITOR='/opt/homebrew/bin/nvim'

# Make $__git_ps1 available, cf.
#   https://stackoverflow.com/questions/15384025/bash-git-ps1-command-not-found
source ~/.bash_git

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

# Git autocompletion for Bash, cf.
#  https://www.macinstruct.com/tutorials/how-to-enable-git-tab-autocomplete-on-your-mac/
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# make Git completion work with g alias
__git_complete g __git_main

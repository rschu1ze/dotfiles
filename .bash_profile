# Called by bash login shells, keep the file super simple

if [ -f ~/.profile ]; then . ~/.profile; fi

if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

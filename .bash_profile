# Called for bash as login shell, keep the file super simple

# The existence of .bash_profile prevents .profile and .bashrc from loading

if [ -f ~/.profile ]; then . ~/.profile; fi

if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

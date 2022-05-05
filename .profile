# Called by login shells, use for stuff not specific to bash, in particular
# environment variables (PATH)

if [ -x "$(command -v /opt/homebrew/bin/brew)" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)" # only for MacOS
fi

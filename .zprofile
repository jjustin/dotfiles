eval "$(/opt/homebrew/bin/brew shellenv)"

if command -v ngrok &>/dev/null; then
	eval "$(ngrok completion)"
fi

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

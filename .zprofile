eval "$(/opt/homebrew/bin/brew shellenv)"

if command -v ngrok &>/dev/null; then
	eval "$(ngrok completion)"
fi

#!/bin/bash

"$(dirname "$0")"/install.brew.sh
eval "$(/opt/homebrew/bin/brew shellenv)"
"$(dirname "$0")"/install.brew-packages.sh
"$(dirname "$0")"/install.oh-my-zsh.sh
"$(dirname "$0")"/install.rosetta.sh
"$(dirname "$0")"/install.aws-cli.sh

echo "Done with installs. Continue with setup script."
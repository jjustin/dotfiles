#!/bin/bash

$(basename "$0")/install.brew.sh
$(basename "$0")/install.brew-packages.sh
$(basename "$0")/install.oh-my-zsh.sh
$(basename "$0")/install.aws-cli.sh

echo "Done with installs. Continue with setup script."
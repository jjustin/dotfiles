#!/bin/bash
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Please install Homebrew before running this script."
    exit 1
fi

formulas=$(cd $(dirname "$0") && comm -23 <(sort brew.txt) <(sort <(brew list --formula -1)))
if [ -z "$formulas" ]; then
	echo "No formulas to install"
else
	brew install --formula $formulas
fi

casks=$(cd $(dirname "$0") && comm -23 <(sort brew-cask.txt) <(sort <(brew list --cask -1)))
if [ -z "$casks" ]; then
	echo "No casks to install"
else
	brew install --cask $casks
fi
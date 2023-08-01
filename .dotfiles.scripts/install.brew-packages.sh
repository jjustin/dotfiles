#!/bin/bash
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Please install Homebrew before running this script."
    exit 1
fi

brew install $(<brew.txt)
brew install --cask $(<brew-cask.txt)

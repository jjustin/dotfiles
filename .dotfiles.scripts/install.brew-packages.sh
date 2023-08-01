#!/bin/bash
brew 2> /dev/null || {echo brew not installed &&  exit 1}

brew install $(<brew.txt)
brew install --cask $(<brew-cask.txt)
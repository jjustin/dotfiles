#!/bin/bash

is_repo=$(command git rev-parse --is-inside-work-tree 2> /dev/null)
if [[ $is_repo != "true" ]]; then
        exit 0
fi

# Currently only supported for paths in $HOME
if [[ $(pwd) == $HOME/* ]]; then
        search_path=$(pwd)
        while [[ ! -z $search_path ]]; do
                # Found gitconfig in some parent directory
                if [[ -f $search_path/.gitconfig ]]; then
                        existing=$(command git config --local --get include.path)
                        # Check if it's not set
                        if [[ $existing == "" ]]; then
                                echo "Found .gitconfig in $search_path. Linking."
                                command git config --local include.path "$search_path/.gitconfig"
                                exit 0
                        # Check if it's set to the found .gitconfig
                        elif [[ $existing != "$search_path/.gitconfig" ]]; then
                                echo "Found .gitconfig in $search_path, but include.path already set to \`$existing\` in local .gitconfig."
                                echo "If it should be overwritten, run 'command git config --unset include.path'"
                                exit 1
                        fi

                        # already set to the found .gitconfig
                        exit 0
                fi
                # Go up one directory
                search_path=$(/usr/bin/dirname "$search_path")
        done
        echo "No .gitconfig found in any parent directory, using default settings"
        exit 0
fi
echo "Not in home directory, not linking .gitconfig"
exit 0

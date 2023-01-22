# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PIPENV_PYTHON="$PYENV_ROOT/shims/python"
PATH=$(pyenv root)/shims:$PATH

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Pupeteer fix
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`

# Golang
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# Run gpg in current tty
export GPG_TTY=$(tty)


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	fzf
        git
	pyenv
        zsh-syntax-highlighting
        zsh-autosuggestions
        z
)

source $ZSH/oh-my-zsh.sh

if [ "$(uname)" = "Darwin" ]; then
        # The next line updates PATH for the Google Cloud SDK.
        if [ -f '/Users/jjustin/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jjustin/google-cloud-sdk/path.zsh.inc'; fi

        # The next line enables shell command completion for gcloud.
        if [ -f '/Users/jjustin/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jjustin/google-cloud-sdk/completion.zsh.inc'; fi
fi

# AWS autocomplete
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/local/bin/aws_completer' aws

# .gitconfig linking
git() {
        link_gitconfig || return
        command git "$@"
}

link_gitconfig() {
        is_repo=$(command git rev-parse --is-inside-work-tree 2> /dev/null)
        if [[ $is_repo != "true" ]]; then
                return 0
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
                                        return 0
                                # Check if it's set to the found .gitconfig
                                elif [[ $existing != "$search_path/.gitconfig" ]]; then
                                        echo "Found .gitconfig in $search_path, but include.path already set to \`$existing\` in .gitconfig."
                                        echo "If it should be overwritten, run 'command git config --unset include.path'"
                                        return 1
                                fi

                                # already set to the found .gitconfig
                                return 0
                        fi
                        # Go up one directory
                        search_path=`/usr/bin/dirname "$search_path"`
                done
                echo "No .gitconfig found in any parent directory"
        fi
        echo "Not in home directory, not linking .gitconfig"
        return 0
}

# Dotfiles
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

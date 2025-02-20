# ZSH-specific settings
export ZSH="$HOME/.oh-my-zsh"

export TZ="America/New_York"

export NIX_PATH="$NIX_PATH:$HOME/.nix-defexpr/channels"

alias uvenv='uv venv >/dev/null'

alias KHI='docker run -p 127.0.0.1:8080:8080 asia.gcr.io/kubernetes-history-inspector/release:latest -access-token="$GCLOUD_TOKEN" > khi.log 2>&1 &'

alias source-devsite='source /google/src/head/depot/google3/devsite/two/tools/aliases.sh'
if source-devsite ; then
  : # echo 'DevSite aliases are available.'
else
  echo 'Sourcing DevSite failed; run `gcert`, then run `source-devsite`.'
fi

# Google Cloud Storage aliases
alias gcs="gcloud storage"
alias gcsls="gcloud storage ls"
alias gcscp="gcloud storage cp"
alias gcsmv="gcloud storage mv"
alias gcsrm="gcloud storage rm"
alias gcscat="gcloud storage cat"
alias gcsync="gcloud storage rsync"
alias gcstat="gcloud storage stat"

# Parallel
alias gcscpp="gcloud storage cp -m"

# Common patterns with wildcards
alias gcslsr="gcloud storage ls -r"  # Recursive list
alias gcsrma="gcloud storage rm -r"  # Remove all recursively

# Bucket management
alias gcsmb="gcloud storage buckets create"
alias gcsrb="gcloud storage buckets delete"
alias gcslb="gcloud storage buckets list"


# Oh My Zsh plugins
plugins=(
    git
    direnv
    docker
    kubectl
    terraform
    python
    golang
    history-substring-search
    zsh-autosuggestions
    zsh-syntax-highlighting
    kubectx
    gcloud
    github
    command-not-found
    jsontools
    dirhistory
)

source $ZSH/oh-my-zsh.sh

# History improvements
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS  # Don't record duplicates in history
setopt HIST_SAVE_NO_DUPS     # Don't save duplicates
setopt HIST_REDUCE_BLANKS    # Remove unnecessary blanks
setopt INC_APPEND_HISTORY    # Add commands to history immediately
setopt EXTENDED_HISTORY      # Record timestamp in history

# Directory navigation
setopt AUTO_PUSHD           # Push the current directory onto the stack
setopt PUSHD_IGNORE_DUPS    # Don't store duplicates in the directory stack
setopt PUSHD_MINUS          # Make `cd -1` work like `cd -`

# Completion improvements
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive completion
zmodload zsh/complist
compinit

# Useful options
setopt AUTO_CD              # If command is directory name, cd into it
setopt CORRECT             # Command correction prompt
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell
setopt NO_CASE_GLOB        # Case insensitive globbing
setopt EXTENDED_GLOB       # Extended globbing capabilities

# Cross-platform clipboard support
if [[ $(uname) == "Linux" ]]; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

# Key bindings
bindkey '^[[A' history-substring-search-up      # Up arrow
bindkey '^[[B' history-substring-search-down    # Down arrow
bindkey '^[[H' beginning-of-line               # Home key
bindkey '^[[F' end-of-line                     # End key
bindkey '^[[3~' delete-char                    # Delete key
bindkey '^[[1;5C' forward-word                 # Ctrl + right
bindkey '^[[1;5D' backward-word                # Ctrl + left
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
# Better directory movement
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Quick edit of zsh config
alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"

# Git shortcuts (if not provided by git plugin)
alias gst='git status'
alias ga='git add'
alias gd='git diff'

# Better defaults
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias mkdir='mkdir -p'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Python alias with uv
alias python="uv run --python 3.12 -- python"

# Path configurations
typeset -U path  # Ensure unique entries
path=(
    $HOME/{bin,go/bin}
    $HOME/.local/bin
    /usr/local/google/home/duncanjames/{.local/bin}
    $path
)
export PATH

# Bazel alias
alias bazel=bazelisk

# Google Cloud aliases
alias gccl="gcloud config configurations list"
alias gcca="gcloud config configurations activate"
alias gcsp="gcloud config set project"
alias gal="gcloud auth login --update-adc"

# Pre-commit alias
alias pc='pre-commit run --all'

# Cross alias
alias cross='/google/bin/releases/opensource/thirdparty/cross/cross'

# Group related environment variables
# Editor
export EDITOR="nano"
export VISUAL="$EDITOR"
export KUBE_EDITOR="$EDITOR"

# Locale
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

# Source terraform and kubectl aliases
[ -f ~/.terraform_aliases ] && source ~/.terraform_aliases
function terraform() { echo "+ terraform $@"; command terraform $@; }

[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases
function kubectl() { echo "+ kubectl $@">&2; command kubectl $@; }

# Create and enter directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Google-specific configurations
gcertstatus --quiet -check_ssh=false || gcert

# Add Starship prompt (since you mentioned wanting to use it)
eval "$(starship init zsh)"

export PATH="$HOME/.tfenv/bin:$PATH"
export VIRTUAL_ENV_DISABLE_PROMPT=1

export GOPATH=$(go env GOPATH)
export PATH=$PATH:$(go env GOPATH)/bin
eval "$(direnv hook zsh)"

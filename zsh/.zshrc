# ZSH prof
# zmodload zsh/zprof

HISTSIZE=100000
SAVEHIST=100000

# Speed up compinit
autoload -Uz compinit
zstyle ':completion:*' rehash true
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache
compinit -C

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

DISABLE_AUTO_UPDATE="true"

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# fix Maven "Too many open files" issue
ulimit -n 32768

if (( $+commands[ondir] )); then
  eval_ondir() {
    eval "`ondir \"$OLDPWD\" \"$PWD\"`"
  }
  chpwd_functions=( eval_ondir $chpwd_functions )
fi

# Secrets live here on the Mac; in workspaces use `workspaces secrets` instead
[[ -f ~/.zshrc.datadog ]] && source ~/.zshrc.datadog

export PATH=$PATH:/usr/local/go/bin

# Update with your preference
export DATADOG_ROOT=~/dd

# Force certain more-secure behaviours from homebrew
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha

# Add devtools binaries in your PATH, so you have access to 'to-staging' and 'branches-status'
# !!! Make sure that this is *after* adding homebrew to PATH if you have brew. !!!
export PATH="$PATH:$DATADOG_ROOT/devtools/bin"

# enchant c library location for pyenchant
[[ "$OSTYPE" == darwin* ]] && PYENCHANT_LIBRARY_PATH=/opt/homebrew/lib/libenchant-2.2.dylib

DEFAULT_USER="corey.finley"

ZSH_THEME="powerlevel10k/powerlevel10k"

AWS_REGION="us-east-1"

export INFRA_ROOT_DIR='/Users/coreyfinley/dev/infra'
export TERM='xterm-256color'
export EDITOR="nvim"
export GIT_EDITOR="nvim"

export PYTHONPATH=$HOME/dd/dogweb/lib:$HOME/dd/dogweb/lib/dogweb-model

if [[ `uname` == 'Linux' ]]; then
  export OS=linux
  export ZPLUG_HOME=~/.zplug
elif [[ `uname` == 'Darwin' ]]; then
  export OS=osx
  export ZPLUG_HOME=/usr/local/opt/zplug
fi


alias preview="fzf --preview 'bat --color \"always\" {}'"
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"


export SPARK_HOME=/usr/local/Cellar/apache-spark/1.0.0
export PYTHONPATH=$SPARK_HOME/libexec/python:$PYTHONPATH

export PATH=$PATH:$SPARK_HOME/bin
export ANSIBLE_LIBRARY=$HOME/Documents/ansible/modules

if [[ "$OSTYPE" == darwin* ]]; then
  export PATH="/usr/local/opt/openssl/bin:$PATH"
  export PATH=$PATH:/opt/homebrew/bin
fi
export PATH=$PATH:/usr/local/go/bin

# Base16 Shell
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"


# macOS only: this resets PATH entirely, which would drop workspace PATH entries
[[ "$OSTYPE" == darwin* ]] && export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin
# export PATH="$HOME/.rbenv/shims:$HOME/bin:$PATH"
export PATH="./bin:$PATH"

alias zshconfig="nvim ~/.zshrc && source ~/.zshrc"
alias ctconfig="nvim ~/.zshrc.catalyst && source ~/.zshrc"
alias zshsource="source ~/.zshrc"
alias nvimconfig="nvim ~/.config/nvim/init.lua"
alias w="watch"

plugins=(git colored-man-pages colorize jsontools)

source $ZSH/oh-my-zsh.sh

autoload -U promptinit
promptinit

# unix
alias tlf="tail -f"
alias ln='ln -v'
alias mkdir='mkdir -p'
alias l='ls'
alias ll='ls -al'
alias lh='ls -Alh'

# git
# alias git="hub"
alias g="git"
alias gb="git branch"
alias gbd="git branch -D"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gri="git rebase -i"
alias gf="git fetch --prune --quiet"
alias lg="lazygit"
alias swtch="git switch -"

function gco () {
  git checkout -t origin/$1
}

function touched-files () {
  git --no-pager diff --name-only $(git branch --show-current) origin/staging  -- . ':(exclude)db/structure.sql' ':(exclude)config/sidekiq_scheduler.yml'
}

function touched-files-main () {
  git --no-pager diff --name-only $(git branch --show-current) origin/main  -- . ':(exclude)db/structure.sql' ':(exclude)config/sidekiq_scheduler.yml'
}

function out-join () {
  awk '{print}' ORS=' '
}


#rails
alias r="rails"

#bundler
alias bx="bundle exec"
alias rx="rbenv exec"

#kbctl
alias kc="kubectl"

#docker-compose
alias dc="docker compose"
alias dcu="docker compose up"
alias dcd="docker compose down"


# tmux
# source ~/tmuxinator.zsh
alias tx="tmuxinator"
alias txc="tmuxinator start catalyst"
alias txx="tmuxinator stop catalyst"

alias tml="tmux list-sessions"
alias tma="tmux -2 attach -t $1"
alias tmk="tmux kill-session -t $1"
alias tmr="tmux rename-window $1"
alias tdir="tmux attach -c \"#{pane_current_path}\""
alias td="tmux set-option default-path \"$PWD\""

alias mas-upgrade="mas outdated | cut -b 1-9 | xargs mas upgrade"

bindkey '^B' clear-screen

rmd () {
  pandoc $1 | lynx -stdin
}

jcurl () {
  curl $* | jq '.'
}

# 1Password CLI: unlock with Touch ID
OP_BIOMETRIC_UNLOCK_ENABLED=true

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/.poetry/bin:$PATH"

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# added by Snowflake SnowSQL installer v1.2
if [[ -d /Applications/SnowSQL.app ]]; then
  export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH
  alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql
fi

# pretty print decoded jwt
function jwt() {
  for part in 1 2; do
    b64="$(cut -f$part -d. <<< "$1" | tr '_-' '/+')"
    len=${#b64}
    n=$((len % 4))
    if [[ 2 -eq n ]]; then
      b64="${b64}=="
    elif [[ 3 -eq n ]]; then
      b64="${b64}="
    fi
    d="$(openssl enc -base64 -d -A <<< "$b64")"
    python -mjson.tool <<< "$d"
    # don't decode further if this is an encrypted JWT (JWE)
    if [[ 1 -eq part ]] && grep '"enc":' <<< "$d" >/dev/null ; then
        exit 0
    fi
  done
}

function current_vol() {
  osascript -e 'set currentVolume to output volume of (get volume settings)'
}

alias rc=docker-compose run web rails console

# Load homebrew environment (sets PATH and other variables)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  # Cache brew prefix to avoid repeated subshell calls in later lines
  HOMEBREW_PREFIX="/opt/homebrew"
fi

# gh tool completion - cache it once instead of generating on every startup
if command -v gh &> /dev/null && [[ ! -f ~/.zsh_completion.d/_gh ]]; then
  mkdir -p ~/.zsh_completion.d
  gh completion -s zsh > ~/.zsh_completion.d/_gh
fi
fpath=(~/.zsh_completion.d $fpath)
# Convert to function so it doesn't execute during shell startup
to-staging() {
  gh pr comment $(gh pr view --json number -q .number) --body "/to-staging"
}

if [[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/share/google-cloud-sdk" ]]; then
  source "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.zsh.inc"
  source "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc"
fi
# BEGIN ANSIBLE MANAGED BLOCK
# Load homebrew shell variables (already loaded, removing duplicate)

# Force certain more-secure behaviours from homebrew
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha
export HOMEBREW_DIR=/opt/homebrew
export HOMEBREW_BIN=/opt/homebrew/bin

# Load python shims
if command -v pyenv &> /dev/null; then
  eval "$(pyenv init -)"
fi

# Prefer GNU binaries to Macintosh binaries.
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# VOLTA
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Add datadog devtools binaries to the PATH
export PATH="$HOME/dd/devtools/bin:$PATH"

# Point GOPATH to our go sources
export GOPATH="$HOME/go"

# Add binaries that are go install-ed to PATH
export PATH="$GOPATH/bin:$PATH"

# Point DATADOG_ROOT to ~/dd symlink
export DATADOG_ROOT="$HOME/dd"

# Tell the devenv vm to mount $GOPATH/src rather than just dd-go
export MOUNT_ALL_GO_SRC=1

# store key in the login keychain instead of aws-vault managing a hidden keychain
export AWS_VAULT_KEYCHAIN_NAME=login

# tweak session times so you don't have to re-enter passwords every 5min
export AWS_SESSION_TTL=24h
export AWS_ASSUME_ROLE_TTL=1h

# Helm switch from storing objects in kubernetes configmaps to
# secrets by default, but we still use the old default.
export HELM_DRIVER=configmap

# Go 1.16+ sets GO111MODULE to off by default with the intention to
# remove it in Go 1.18, which breaks projects using the dep tool.
# https://blog.golang.org/go116-module-changes
export GO111MODULE=auto
export GOPRIVATE=github.com/DataDog
# Configure Go to pull go.ddbuild.io packages.
export GOPROXY=binaries.ddbuild.io,https://proxy.golang.org,direct
export GONOSUMDB=github.com/DataDog,go.ddbuild.io
# END ANSIBLE MANAGED BLOCK
# Lazy-load GITLAB_TOKEN to avoid keychain lookup on every shell start
gitlab_token() {
  export GITLAB_TOKEN=$(security find-generic-password -a ${USER} -s gitlab_token -w)
}
# Uncomment if you need GITLAB_TOKEN available immediately:
# export GITLAB_TOKEN=$(security find-generic-password -a ${USER} -s gitlab_token -w)

# Load commit signing SSH Key if not in the agent already
# (macOS only; workspaces configure commit signing themselves)
if [[ "$OSTYPE" == darwin* ]]; then
  ssh-add -l 2> /dev/null | grep "+git-commit-signing@datadoghq.com" > /dev/null || ssh-add --apple-use-keychain "$HOME/.ssh/datadog_git_commit_signing" 2> /dev/null
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
sdk() {
  unset -f sdk
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
  sdk "$@"
}

if [[ -n "$HOMEBREW_PREFIX" ]]; then
  export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/openssl/lib/pkgconfig:$PKG_CONFIG_PATH"
  export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
  export CPATH="$HOMEBREW_PREFIX/include:$CPATH"
  export LIBRARY_PATH="$HOMEBREW_PREFIX/lib:$LIBRARY_PATH"
  [[ -f "$HOMEBREW_PREFIX/share/zsh/site-functions/_ddtool" ]] && source "$HOMEBREW_PREFIX/share/zsh/site-functions/_ddtool"
fi

# eval "$(direnv hook zsh)"
alias bzl_tidy="bzl run //domains/api_platform/apps/tidy"


# Cache kubectl completion instead of generating on every startup
if command -v kubectl &> /dev/null && [[ ! -f ~/.zsh_completion.d/_kubectl ]]; then
  mkdir -p ~/.zsh_completion.d
  kubectl completion zsh > ~/.zsh_completion.d/_kubectl 2>/dev/null
fi

# zprof

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


alias ghco="gh pr checkout"
alias myprs="gh pr list --author '@me'"
alias opr="gh pr view -w"
oprc() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    gh pr view -w "$(git rev-parse --abbrev-ref HEAD)"
  else
    echo "Not in a git repository."
  fi
}

# watch PR - send a mac notification when a PR ci checks complete (not super reliable)
function wpr() {
        prtitle=$(gh pr view --json "title" | jq '.title' | sed s/\"//g)
        gh pr checks --watch > /dev/null 2>&1
        notification "PR CI checks finished" "$prtitle"
}

# create PR
function cpr() {
       gh pr create -d -a "@me"
       opr
       (sleep 350 ; wpr) &
}

#     [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
export PATH=$HOME/dd/dd-source/domains/workflow/tools/bin:$PATH
export DENO_DIR="$HOME/.deno"

# ZSH prof
# zprof


# Created by `pipx` on 2025-10-20 12:40:35
export PATH="$PATH:$HOME/.local/bin"

# BEGIN SCFW MANAGED BLOCK
alias npm="scfw run npm"
alias pip="scfw run pip"
alias poetry="scfw run poetry"
export SCFW_DD_AGENT_LOG_PORT="10365"
export SCFW_DD_LOG_LEVEL="ALLOW"
export SCFW_HOME="$HOME/.scfw"
# END SCFW MANAGED BLOCK

alias connect="bash ~/dd/dd-source/domains/case_management/etc/tools/connect.sh"

# Added by Yarn Switch
[[ -f "$HOME/.yarn/switch/env" ]] && source "$HOME/.yarn/switch/env"

base_branch() {
  gh repo view --json defaultBranchRef --jq .defaultBranchRef.name
}

# Trajectory - AI coding agent observability
export PATH="$HOME/.trajectory/bin:$PATH"

[ -f "/opt/dogbrew/share/etc/dogbrew/init.zsh" ] && . "/opt/dogbrew/share/etc/dogbrew/init.zsh"

# Pi
[[ -d "$HOME/.volta/tools/image/node/24.14.1/bin" ]] && export PATH="$HOME/.volta/tools/image/node/24.14.1/bin:$PATH"

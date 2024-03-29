# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

eval_ondir() {
  eval "`ondir \"$OLDPWD\" \"$PWD\"`"
}


chpwd_functions=( eval_ondir $chpwd_functions )

if [ ! -f /Users/corey/dev/catalyst/.zshrc.catalyst ]; then
  source ~/.zshrc.catalyst
fi

source ~/.zshrc.secrets

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

#ZSH_THEME="clean"
ZSH_THEME="spaceship"
DEFAULT_USER="corey"

SPACESHIP_TIME_SHOW=true
SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  # package       # Package version
  # node          # Node.js section
  # ruby          # Ruby section
  # docker        # Docker section
  # kubectl       # Kubectl context section
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

AWS_REGION="us-east-1"

export INFRA_ROOT_DIR='/Users/coreyfinley/dev/infra'
export TERM='xterm-256color'
export EDITOR="vim"

if [[ `uname` == 'Linux' ]]; then
  export OS=linux
  export ZPLUG_HOME=~/.zplug
elif [[ `uname` == 'Darwin' ]]; then
  export OS=osx
  export ZPLUG_HOME=/usr/local/opt/zplug
fi

#export CC=/usr/local/Cellar/apple-gcc42/4.2.1-5666.3/bin/gcc-4.2
#export CXX=/usr/local/Cellar/apple-gcc42/4.2.1-5666.3/bin/g++-4.2
#export CPP=/usr/local/Cellar/apple-gcc42/4.2.1-5666.3/bin/cpp-4.2

#export CC=/usr/local/Cellar/gcc48/4.8.5/bin/gcc-4.8
#export CXX=/usr/local/Cellar/gcc48/4.8.5/bin/g++-4.8
#export CXX=/usr/local/Cellar/gcc48/4.8.5/bin/cpp-4.8

alias preview="fzf --preview 'bat --color \"always\" {}'"
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"


export SPARK_HOME=/usr/local/Cellar/apache-spark/1.0.0
export PYTHONPATH=$SPARK_HOME/libexec/python:$PYTHONPATH

export PATH=$PATH:$SPARK_HOME/bin
export ANSIBLE_LIBRARY=$HOME/Documents/ansible/modules

export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH=$PATH:/opt/homebrew/bin
export PATH=$PATH:/usr/local/go/bin

# Base16 Shell
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"


export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin
# export PATH="$HOME/.rbenv/shims:$HOME/bin:$PATH"
# eval "$(rbenv init -)"
export PATH="./bin:$PATH"

alias zshconfig="vim ~/.zshrc && source ~/.zshrc"
alias ctconfig="vim ~/.zshrc.catalyst && source ~/.zshrc"
alias zshsource="source ~/.zshrc"
alias vimconfig="vim ~/.vimrc.after"
alias w="watch"

#plugins=(git battery)
#plugins=(git battery history-substring-search colored-man-pages colorize jsontools fast-syntax-highlighting)
plugins=(git battery history-substring-search colored-man-pages colorize jsontools)

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
alias gf="git fetch --prune"

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

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/coreyfinley/.asdf/installs/nodejs/10.15.2/.npm/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/coreyfinley/.asdf/installs/nodejs/10.15.2/.npm/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/coreyfinley/.asdf/installs/nodejs/10.15.2/.npm/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/coreyfinley/.asdf/installs/nodejs/10.15.2/.npm/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/coreyfinley/.asdf/installs/nodejs/10.15.2/.npm/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/coreyfinley/.asdf/installs/nodejs/10.15.2/.npm/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


export PATH="$HOME/.poetry/bin:$PATH"

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# added by Snowflake SnowSQL installer v1.2
export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH
alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql

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

eval $(/opt/homebrew/bin/brew shellenv)
# gh tool completion
eval "$(gh completion -s zsh)"
. /opt/homebrew/opt/asdf/libexec/asdf.sh

export PATH=$PATH:/usr/local/go/bin

function print_header() {
    echo "============================================================================================================="
    echo "$1"
    echo "============================================================================================================="
}

function make_space() {
    echo "============================================================================================================="
    echo
    echo
    echo
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/corey/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/corey/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/corey/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/corey/google-cloud-sdk/completion.zsh.inc'; fi

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

ZSH_THEME="agnoster"
#ZSH_THEME="avit"
DEFAULT_USER="coreyfinley"

AWS_REGION="us-east-1"

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

export SPARK_HOME=/usr/local/Cellar/apache-spark/1.0.0
export PYTHONPATH=$SPARK_HOME/libexec/python:$PYTHONPATH

export PATH=$PATH:$SPARK_HOME/bin
export ANSIBLE_LIBRARY=$HOME/Documents/ansible/modules

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/base16-bright.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin
export PATH="$HOME/.rbenv/shims:$HOME/bin:$PATH"
eval "$(rbenv init -)"
export PATH="./bin:$PATH"

alias zshconfig="vim ~/.zshrc && source ~/.zshrc"
alias vimconfig="vim ~/.vimrc.after"

#plugins=(git battery)
plugins=(git battery history-substring-search colored-man colorize)

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


#rails
alias r="rails"
alias migrate="rake db:migrate && rake db:test:prepare && spring stop"
alias refreshdb="~/drop_db.sh"

#elstic dump
alias edump="elasticdump --input=https://ghostFacedKilla:casHRul353v3rY7HiNgAr0undM3@a5e6a3f487180f34000.qbox.io/$2 --output=http://localhost:9200/$3 --type=$1"

#workers
alias worker:clean="rake jobs:clear"
alias worker:start="rake jobs:work"

#bundler
alias bx="bundle exec"
alias rx="rbenv exec"

# tmux
alias tx="tmuxinator"

alias tml="tmux list-sessions"
alias tma="tmux -2 attach -t $1"
alias tmk="tmux kill-session -t $1"
alias tmr="tmux rename-window $1"

# speak
alias hbspeak="curl -s -H \"Content-Type: application/json\" -d '{ \"auth_token\": \"PANDAMOUSE\", \"room\" : \"tech-deployments\", \"msg\" : $2}' 'https://honeyb.herokuapp.com/speak'"

alias tacocat="bin/eb deploy qa4"

# eb
alias deploy="eb deploy"
alias status="eb status"

#release
function release {
  local url
  url="https://evilolive.herokuapp.com/deployed?env=$1&branch=AVAILABLE&user="
  curl -s -d '{ \"auth_token\": \"PANDAMOUSE\" }' $url
}

# added by travis gem
[ -f /Users/coreyfinley/.travis/travis.sh ] && source /Users/coreyfinley/.travis/travis.sh

bindkey '^B' clear-screen

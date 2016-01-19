# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"
#ZSH_THEME="bureau"
#ZSH_THEME="avit"
DEFAULT_USER="coreyfinley"

export TERM='xterm-256color'
export EDITOR="vim"

export CC=/usr/local/Cellar/apple-gcc42/4.2.1-5666.3/bin/gcc-4.2
export CXX=/usr/local/Cellar/apple-gcc42/4.2.1-5666.3/bin/g++-4.2
export CPP=/usr/local/Cellar/apple-gcc42/4.2.1-5666.3/bin/cpp-4.2

export SPARK_HOME=/usr/local/Cellar/apache-spark/1.0.0
export PYTHONPATH=$SPARK_HOME/libexec/python:$PYTHONPATH

export PATH=$PATH:$SPARK_HOME/bin
export PATH=./bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin
export PATH="$HOME/.rbenv/shims:$HOME/bin:$PATH"

eval "$(rbenv init -)"

alias zshconfig="vim ~/.zshrc"
alias vimconfig="vim ~/.vimrc.after"

plugins=(git)
plugins=(history-substring-search colored-man colorize)

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
alias gf="git fetch"


#rails
alias r="rails"
alias migrate="bin/rake db:migrate && bin/rake db:test:prepare"

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

alias tacocat="bin/eb deploy qa4"

# added by travis gem
[ -f /Users/coreyfinley/.travis/travis.sh ] && source /Users/coreyfinley/.travis/travis.sh

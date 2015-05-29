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

export CC=/usr/local/Cellar/apple-gcc42/4.2.1-5666.3/bin/gcc-4.2
export CXX=/usr/local/Cellar/apple-gcc42/4.2.1-5666.3/bin/g++-4.2
export CPP=/usr/local/Cellar/apple-gcc42/4.2.1-5666.3/bin/cpp-4.2

export SPARK_HOME=/usr/local/Cellar/apache-spark/1.0.0
export PYTHONPATH=$SPARK_HOME/libexec/python:$PYTHONPATH
export PATH=$PATH:$SPARK_HOME/bin

# User configuration
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin
export PATH="$HOME/.rbenv/shims:$HOME/bin:$PATH"
#export PATH=$PATH:$HOME/AWS-EB/eb/macosx/python2.7/
eval "$(rbenv init -)"
# Example aliases
# alias zshconfig="vim ~/.zshrc"
# alias ohmyzsh="vim ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp 
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)
plugins=(history-substring-search colored-man colorize)

source $ZSH/oh-my-zsh.sh
#source /usr/bin/tmuxinator.zsh


#function deploy(){cap deploy -S rails_env="staging" -S branch=$@}
export EDITOR="vim"

#export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"
# export MANPATH="/usr/local/man:$MANPATH"

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
alias gp="git pull"


#rails
alias migrate="rake db:migrate && rake db:test:prepare"
alias rs="rails s"
alias rc="rails c"

#elstic dump
alias edump="elasticdump --input=https://ghostFacedKilla:casHRul353v3rY7HiNgAr0undM3@a5e6a3f487180f34000.qbox.io/$2 --output=http://localhost:9200/$3 --type=$1"

#workers
alias worker:clean="rake jobs:clear"
alias worker:start="rake jobs:work"
alias migrate="bundle exec rake db:migrate db:test:prepare"

#bundler
alias bx="bundle exec"
alias rx="rbenv exec"

alias startmongo="mongod --config /usr/local/etc/mongod.conf"

alias ping_qb1="ping a5e6a3f487180f34000.qbox.io"
alias ping_qb2="ping a5e6a3f487180f34001.qbox.io"

alias tx="tmuxinator"

function deploy(){bundle exec cap deploy -S rails_env="staging" -S branch=$@}

alias tml="tmux list-sessions"
alias tma="tmux -2 attach -t $1"
alias tmk="tmux kill-session -t $1"
alias tmr="tmux rename-window $1"

alias ebd="bin/rake  eb:deploy\\[$1\\]"

alias cons="bin/rails c"

alias staging-push="git aws.push --env rza-staging"
alias production-push="git aws.push --env rza-production"

# added by travis gem
[ -f /Users/coreyfinley/.travis/travis.sh ] && source /Users/coreyfinley/.travis/travis.sh

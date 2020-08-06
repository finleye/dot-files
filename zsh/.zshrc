# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# source ~/.zshrc.tokens
source ~/.zshrc.catalyst

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

#ZSH_THEME="agnoster"
# ZSH_THEME="avit"
ZSH_THEME="clean"
DEFAULT_USER="coreyfinley"

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

# Base16 Shell
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"


export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin
# export PATH="$HOME/.rbenv/shims:$HOME/bin:$PATH"
# eval "$(rbenv init -)"
export PATH="./bin:$PATH"

alias zshconfig="vim ~/.zshrc && source ~/.zshrc"
alias vimconfig="vim ~/.vimrc.after"

#plugins=(git battery)
plugins=(git battery history-substring-search colored-man-pages colorize)

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

#bundler
alias bx="bundle exec"
alias rx="rbenv exec"

#kbctl
alias kc="kubectl"

#docker-compose
alias dc="docker-compose"


# tmux
# source ~/tmuxinator.zsh
alias tx="tmuxinator"

alias tml="tmux list-sessions"
alias tma="tmux -2 attach -t $1"
alias tmk="tmux kill-session -t $1"
alias tmr="tmux rename-window $1"
alias tdir="tmux attach -c \"#{pane_current_path}\""

alias mas-upgrade="mas outdated | cut -b 1-9 | xargs mas upgrade"

bindkey '^B' clear-screen

. $HOME/.asdf/asdf.sh


rmd () {
  pandoc $1 | lynx -stdin
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

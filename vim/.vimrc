if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'ervandew/supertab'
Plugin 'easymotion/vim-easymotion'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'rking/ag.vim'
Plugin 'thoughtbot/pick.vim'
Plugin 'stefandtw/quickfix-reflector.vim'
Plugin 'AndrewRadev/splitjoin.vim'
Plugin 'godlygeek/tabular'
Plugin 'jgdavey/tslime.vim'
Plugin 'jgdavey/vim-turbux'
Plugin 'vim-scripts/YankRing.vim'
Plugin 'vim-ruby/vim-ruby'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'tomtom/tcomment_vim'
Plugin 'thoughtbot/vim-rspec'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'ianks/vim-tsx'

"tpope
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-rails'



call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.after
endif

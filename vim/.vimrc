if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

set nocompatible              " be iMproved, required
" filetype off                  " required

" set the runtime path to include Vundle and initialize

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
" Plugin 'altercation/vim-colors-solarized'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'ervandew/supertab'
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

"tpope
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-rails'

Plugin 'kchmck/vim-coffee-script'
Plugin 'chriskempson/base16-vim'
Plugin 'ianks/vim-tsx'
Plugin 'leafgarland/typescript-vim'

call vundle#end()

if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif

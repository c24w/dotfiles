set nocompatible               " stops vim from behaving in a strongly vi-compatible way
filetype off

set nu
set tabstop=4
set shiftwidth=4

set colorcolumn=80

au GUIEnter * simalt ~x		" start maximised

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
Bundle 'altercation/vim-colors-solarized'

syntax on
colorscheme solarized
set guifont=Lucida_Console:h10:cANSI
set backupdir=~/.backups

noremap <F2> :NERDTreeToggle<CR>

set backspace=indent,eol,start

set nocompatible               " stops vim from behaving in a strongly vi-compatible way
set cursorline
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
Bundle 'pangloss/vim-javascript'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-unimpaired'
Bundle 'mustache/vim-mustache-handlebars'

syntax on
colorscheme solarized
set guifont=Lucida_Console:h10:cANSI
highlight Cursor guifg=black guibg=grey
highlight iCursor guifg=black guibg=grey
set guicursor=n-v:block-Cursor
set guicursor+=i-c:ver25-iCursor
set backupdir=~/.vim/.backup//
set directory=~/.vim/.swp//

set hidden

set incsearch
set hlsearch

set foldmethod=syntax

"Indentation
filetype plugin indent on
set autoindent

noremap <F2> :NERDTreeToggle<CR>

set backspace=indent,eol,start

set list
set listchars=tab:›\ ,eol:¬

let g:ctrlp_root_markers = ['.ctrlp_root']

"Maps space to clear search highlighting
nmap <SPACE> <SPACE>:noh<CR>

"Folding - unfold everything by default
au BufRead * normal zR

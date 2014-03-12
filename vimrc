set nocompatible "Stop vim from behaving in a strongly vi-compatible way
set backupdir=~/.vim/.backup//
set directory=~/.vim/.swp//
set hidden "Keep buffers open when opening new buffers
set incsearch "Search as typed
set hlsearch
filetype off

set list "Show whitespace
set listchars=tab:›\ ,eol:¬

set backspace=indent,eol,start "Allow backspacing over these chars

" Indentation
"""""""""""""
filetype plugin indent on
set autoindent
set tabstop=4 "Tab width
set shiftwidth=4 "Re-indent width


" File reading
""""""""""""""""
scriptencoding utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileformats=unix,dos


" Appearance
""""""""""""""
syntax on
set number "Line numbers
set cursorline
set colorcolumn=80
set background=dark
colorscheme solarized

highlight Cursor guifg=black guibg=grey
highlight iCursor guifg=black guibg=grey
highlight SpecialKey ctermbg=none

if has("gui_running")
	au GUIEnter * simalt ~x "Maximise
	set guioptions-=m  "Remove menu bar
	set guioptions-=T  "Remove toolbar
	set guicursor=n-v:block-Cursor
	set guicursor+=i-c:ver25-iCursor
	set guifont=Inconsolata:h12:cANSI
endif

if $COLORTERM == 'gnome-terminal'
	"Use 256 colours
	set t_Co=256
endif


" Plugins
"""""""""""
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
let g:ctrlp_root_markers = ['.ctrlp_root']

Bundle 'tpope/vim-unimpaired'
Bundle 'mustache/vim-mustache-handlebars'
Bundle 'mileszs/ack.vim'
Bundle 'christoomey/vim-tmux-navigator'


" Bindings
""""""""""""
noremap <F2> :NERDTreeToggle<CR>
"
"Clear search higlighting
nmap <SPACE> <SPACE>:noh<CR>


set foldmethod=syntax
"Unfold everything by default
au BufRead * normal zR

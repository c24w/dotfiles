" File reading
""""""""""""""""
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif


set fileformats=unix,dos
set nocompatible "Stop vim from behaving in a strongly vi-compatible way
set backupdir=~/.vim/.backup//
set directory=~/.vim/.swp//
set hidden "Keep buffers open when opening new buffers
set incsearch "Search as typed
set hlsearch
filetype off

set list "Show whitespace
set backspace=indent,eol,start "Allow backspacing over these chars

set listchars=tab:›\ ,eol:¬


" Indentation
"""""""""""""
filetype plugin indent on
set autoindent
set tabstop=4 "Tab width
set shiftwidth=4 "Re-indent width


" Appearance
""""""""""""""
syntax on
au BufNewFile,BufRead *.handlebars setlocal filetype=mustache
set number "Line numbers
set cursorline
if expand("%:t:r") == "COMMIT_EDITMSG"
	" Show at git commit recommended length
	set colorcolumn=51
else
	set colorcolumn=80
endif
set background=dark

highlight Cursor guifg=black guibg=grey
highlight iCursor guifg=black guibg=grey
"highlight SpecialKey ctermbg=none "No tab background colour

if $COLORTERM == 'gnome-terminal'
	"Use 256 colours
	set t_Co=256
endif

if has("gui_running")
	au GUIEnter * simalt ~x "Maximise
	set guioptions-=m "Remove menu bar
	set guioptions-=T "Remove toolbar
	set guicursor=n-v:block-Cursor
	set guicursor+=i-c:ver25-iCursor
	set guifont=Inconsolata:h12:cANSI
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
colorscheme solarized

Bundle 'pangloss/vim-javascript'

Bundle 'kien/ctrlp.vim'
let g:ctrlp_root_markers = ['.ctrlp_root']
let g:ctrlp_custom_ignore = {
\ 'dir':  '/build/',
\ }

Bundle 'vim-scripts/BufOnly.vim'
Bundle 'tpope/vim-unimpaired'
Bundle 'mustache/vim-mustache-handlebars'
Bundle 'mileszs/ack.vim'
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'bling/vim-airline'
set laststatus=2
let g:airline_theme = 'solarized'
let g:airline_enable_branch = 1
let g:airline_enable_syntastic = 1
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_branch_prefix = '⭠'
let g:airline_readonly_symbol = '⭤'
let g:airline_linecolumn_prefix = '⭡'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#close_symbol = '×'
let g:airline#extensions#tabline#left_sep = '⮀'
let g:airline#extensions#tabline#right_sep = '⮂'
let g:airline#extensions#whitespace#checks = [ 'trailing' ]
let g:airline#extensions#whitespace#trailing_format = '%s:trailing'


" Bindings
""""""""""""
noremap <F2> :NERDTreeToggle<CR>
"Clear line with Ctrl-Space
nmap <C-@> 0D
"Clear search higlighting
nmap <SPACE> <SPACE>:noh<CR>
"Save with W
command W w
"Prevent NT going really wide and don't accidentally db NT
cnoreabbrev bd NERDTreeClose<CR>:bd<CR>

set foldmethod=syntax
"Unfold everything by default
au BufRead * normal zR

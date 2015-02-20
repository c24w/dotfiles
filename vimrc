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
"Case-insensitive search, unless mixed case is used
set ignorecase
set smartcase
"Apply smartcase to * and #
:nnoremap * /\<<C-R>=expand('<cword>')<CR>\><CR>
:nnoremap # ?\<<C-R>=expand('<cword>')<CR>\><CR>
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
set background=dark

if expand("%:t:r") == "COMMIT_EDITMSG"
	" Show at git commit recommended length
	set colorcolumn=50
	set textwidth=50
else
	set colorcolumn=80
endif

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
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-scripts/BufOnly.vim'
Plugin 'tpope/vim-unimpaired'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'rking/ag.vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'pangloss/vim-javascript'
Plugin 'milkypostman/vim-togglelist'
Plugin 'gmarik/vundle'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdtree'
Plugin 'altercation/vim-colors-solarized'
colorscheme solarized

Plugin 'vim-scripts/HTML-AutoCloseTag'
au FileType mustache so ~/.vim/bundle/HTML-AutoCloseTag/ftplugin/html_autoclosetag.vim
 
Plugin 'scrooloose/syntastic'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump = 1
let g:syntastic_check_on_open = 1
let g:syntastic_aggregate_errors = 1

Plugin 'kien/ctrlp.vim'
let g:ctrlp_root_markers = ['.ctrlp_root']
let g:ctrlp_custom_ignore = {
\ 'dir':  '/build/',
\ }

Plugin 'bling/vim-airline'
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

call vundle#end()
filetype plugin indent on

" Bindings
""""""""""""
function! BD()
	let ntIsFocus = exists("b:NERDTreeType")
	if ntIsFocus
		"Don't accidentally bd NT
		NERDTreeClose
	endif

	"Don't lose splits
	b# "Go to last used buffer
	bd # "Close previous buffer (buffer before b#)
	try 
		buffer
	catch
		"Last used buffer we've ended up in has previously been bd'd (hidden)
		"bd again to hide it and go to a visible buffer
		bd
	endtry

	if ntIsFocus
		"Restore NT
		NERDTreeFocus
	endif
endfunction

noremap <F2> :NERDTreeToggle<CR>
"Clear line with Ctrl-Space
nmap <C-@> 0D
"Clear search higlighting
nmap <SPACE> <SPACE>:noh<CR>
map <Leader>bo :BufOnly<CR>
"Save with W
command W w
map <Leader>bd :call BD()<CR>
"Ag shortcut to not auto-open first result
map <Leader>a :Ag!<Space>
"Show current file in NT
map <Leader>f :NERDTreeFind<CR>
"Toggle paste/nopaste
set pastetoggle=<Leader>p

set foldmethod=syntax

"Use local vimrcs
set exrc
set secure

"Unfold everything by default
au BufRead * normal zR

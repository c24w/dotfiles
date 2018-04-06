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

set backspace=indent,eol,start "Allow backspacing over these chars

set list "Show whitespace
set listchars=tab:›\ ,eol:¬

set wildmenu "Tab through files with :e


" Indentation
"""""""""""""
filetype plugin indent on
set autoindent
set expandtab "Spaces
set tabstop=2 "Tab width
set shiftwidth=2 "Re-indent width


" Appearance
""""""""""""""
syntax on
au BufNewFile,BufRead *.handlebars setlocal filetype=mustache
au BufNewFile,BufRead *.ts setlocal filetype=typescript
set number "Line numbers
set cursorline
set background=dark

if expand('%:t:r') == 'COMMIT_EDITMSG'
  "Show commit message and summary line length suggestions
  set colorcolumn=50,72
  "Auto-wrap summary to suggested length
  set textwidth=72
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

Plugin 'gmarik/vundle'
Plugin 'Shougo/vimproc.vim'
Plugin 'Quramy/tsuquyomi'
Plugin 'gmarik/Vundle.vim'
Plugin 'shime/vim-livedown'
Plugin 'vim-scripts/BufOnly.vim'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-commentary'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'pangloss/vim-javascript'
Plugin 'milkypostman/vim-togglelist'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-repeat'
Plugin 'altercation/vim-colors-solarized'
Plugin 'ntpeters/vim-better-whitespace'

Plugin 'mileszs/ack.vim'
let g:ackprg = 'ag --vimgrep --smart-case'

Plugin 'leafgarland/typescript-vim'
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi']

Plugin 'vim-scripts/HTML-AutoCloseTag'
au FileType mustache so ~/.vim/bundle/HTML-AutoCloseTag/ftplugin/html_autoclosetag.vim

Plugin 'bronson/vim-visual-star-search'

Plugin 'scrooloose/syntastic'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump = 1
let g:syntastic_check_on_open = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_javascript_checkers = ['jscs', 'jshint', 'eslint']

Plugin 'ctrlpvim/ctrlp.vim'
let g:ctrlp_root_markers = ['.ctrlp_root']
" Ignores only work when not using a user_command
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](node_modules|\.git)$',
  \ 'file': '\v\.(png,jpg)$'
  \ }
"Use ag or git for autocompletion
let g:ctrlp_use_caching = 0
" if executable('ag')
"   set grepprg=ag\ --nogroup\ --nocolor\ --ignore
"   let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
" else
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
  let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<space>', '<cr>', '<2-LeftMouse>'],
    \ }
" endif

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
set laststatus=2
let g:airline_theme = 'solarized'
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
"let g:airline_symbols.readonly = '⭤'
"let g:airline_symbols.branch = '⭠'
"let g:airline_symbols.linenr = '⭡'
let g:airline_branch_prefix = '⭠'
let g:airline_readonly_symbol = '⭤'
let g:airline_linecolumn_prefix = '⭡'
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#close_symbol = '×'
let g:airline#extensions#tabline#left_sep = '⮀'
let g:airline#extensions#tabline#right_sep = '⮂'
let g:airline#extensions#whitespace#checks = [ 'trailing' ]
let g:airline#extensions#whitespace#trailing_format = '%s:trailing'

call vundle#end()
filetype plugin indent on

colorscheme solarized "Doesn't work in windows if inside vundle calls

" Bindings
""""""""""""
function! BD()
  let restoreStateCmds = []
  "Don't accidentally delete certain buffers
  if @% == 'NERD_tree_1'
    NERDTreeClose
    :call add(restoreStateCmds, 'NERDTreeFocus')
  endif
  if &buftype == 'quickfix'
    ccl
    :call add(restoreStateCmds, 'copen')
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

  for cmd in restoreStateCmds
    execute(cmd)
  endfor
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
"Ack shortcut to not auto-open first result
map <Leader>a :Ack!<Space>''<left>
"Show current file in NT
map <Leader>f :NERDTreeFind<CR>
"Toggle paste/nopaste
set pastetoggle=<Leader>p
"Select pasted text
noremap gp `[v`]
"'Visual' directional movement
noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj
onoremap <buffer> <silent> k gk
onoremap <buffer> <silent> j gj
"Not on my watch
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

let s:ES6ifyFnsPattern='\(\%(return \)\|[:,(=]\_s*\)function[^(]*\(([^)]*)\)'
let s:ES6ifyTidyPattern='(\([a-z0-9$_]\+\)) =>'

function! ES6ify(scope)
  " Convert applicable functions to () =>
  :execute a:scope . 'substitute/' . s:ES6ifyFnsPattern . '/\1\2 =>/ge'
  " Strip superfluous fat arrow function parentheses
  :execute a:scope . 'substitute/' . s:ES6ifyTidyPattern . '/\1 =>/gei'
endfunction
command ES6ifyLine :call ES6ify('')
command ES6ify :call ES6ify('%')

"Don't automatically insert comment chars near other comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"No ESC delays (https://www.johnhawthorn.com/2012/09/vi-escape-delays)
set timeoutlen=1000 ttimeoutlen=0

"Use local vimrcs
set exrc
set secure

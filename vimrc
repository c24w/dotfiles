" Come on Windows
if has('win32') || has('win64')
  set runtimepath^=~/.vim
  set runtimepath^=~/.vim/after
endif

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
nnoremap * /\<<C-R>=expand('<cword>')<CR>\><CR>
nnoremap # ?\<<C-R>=expand('<cword>')<CR>\><CR>
set hlsearch

set wildmenu "Tab through files with :e


" Indentation
"""""""""""""
set autoindent
set expandtab "Spaces
set tabstop=2 "Tab width
set shiftwidth=2 "Re-indent width


" Plugins
"""""""""""
"Vim plug first-time setup
if empty(glob('~/.vim/autoload/plug.vim'))
  if !executable('curl')
    echom "Can't set up plugins without cURL!"
    quit!
  endif

  if has('win32') || has('win64')
    execute 'silent !curl -fkLo "'.$HOME.'\.vim\autoload\plug.vim" --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  else
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  endif

  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'Yggdroot/indentLine'
let g:indentLine_char = '┆'
let g:indentLine_color_term = 10
"https://git.io/vxdyE
Plug 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0

Plug 'editorconfig/editorconfig-vim'
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

Plug 'Shougo/vimproc.vim'
Plug 'Quramy/tsuquyomi'
Plug 'shime/vim-livedown'
Plug 'vim-scripts/BufOnly.vim'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'christoomey/vim-tmux-navigator'
Plug 'pangloss/vim-javascript'
Plug 'milkypostman/vim-togglelist'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-repeat'
Plug 'ntpeters/vim-better-whitespace'

Plug 'mileszs/ack.vim'
let g:ackprg = 'ag --vimgrep --smart-case'

Plug 'mustache/vim-mustache-handlebars'
au BufNewFile,BufRead *.handlebars setlocal filetype=mustache

Plug 'vim-scripts/HTML-AutoCloseTag'
au FileType mustache so ~/.vim/bundle/HTML-AutoCloseTag/ftplugin/html_autoclosetag.vim

" Show commit line length suggestions and auto-wrap at suggested length
au FileType gitcommit ++once set colorcolumn=50,72
au FileType gitcommit ++once set textwidth=72

Plug 'bronson/vim-visual-star-search'

Plug 'scrooloose/syntastic'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump = 1
let g:syntastic_check_on_open = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_javascript_checkers = ['jscs', 'jshint', 'eslint']

Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_root_markers = ['.ctrlp_root']
" Ignores only work when not using a user_command
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](node_modules|\.git)$',
  \ 'file': '\v\.(png,jpg)$'
  \ }
"Use ag or git for autocompletion
let g:ctrlp_use_caching = 0
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --ignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

Plug 'altercation/vim-colors-solarized'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

call plug#end()


" Appearance
""""""""""""""
set number
set cursorline
set background=dark
set colorcolumn=80

highlight Cursor guifg=black guibg=grey
highlight iCursor guifg=black guibg=grey

set backspace=indent,eol,start "Allow backspacing over these chars

set nofixendofline

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

"Silence errors so it won't block first-time plugin install with an error
silent! colorscheme solarized

set list "Show whitespace
set listchars=tab:┆\ ,eol:¬

"Restyle tabs (etc)
highlight SpecialKey ctermbg=none ctermfg=10 cterm=none

set scrolloff=1


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
"Fat-fingers
command! W w
command! Q q
command! Wq wq
command! Qa qa
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
nnoremap <buffer> <silent> k gk
nnoremap <buffer> <silent> j gj
vnoremap <buffer> <silent> k gk
vnoremap <buffer> <silent> j gj
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
command! ES6ifyLine :call ES6ify('')
command! ES6ify :call ES6ify('%')

"Don't automatically insert comment chars near other comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"No ESC delays (https://www.johnhawthorn.com/2012/09/vi-escape-delays)
set timeoutlen=1000 ttimeoutlen=0

"Use local vimrcs
set exrc
set secure

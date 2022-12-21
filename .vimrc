" ----------------------------------
" general
" ----------------------------------

syntax on
filetype plugin indent on

set clipboard=unnamed,unnamedplus
set textwidth=0
set timeoutlen=100
set noswapfile
set completeopt=menuone,noinsert,noselect
set encoding=utf-8
set fileencoding=utf-8
set bs=2  " backspace

" ----------------------------------
" gui
" ----------------------------------

set bg=dark
set shortmess=I  " disable vim intro
set termguicolors
set cursorline
hi CursorLine cterm=NONE
set guicursor=n-v-c:block-Cursor
set guicursor+=i:block-iCursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkon0
set ruler
set number
set showmatch
set foldmethod=marker
set splitright
set splitbelow
set linebreak
set laststatus=3

" fix tmux colorscheme issue
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" windows gvim
if has('win32') && has('gui_running')
    set guifont=Cascadia\ Mono:h12
    colorscheme torte
    "hi CursorLine cterm=NONE
endif

" ----------------------------------
" tabs, indent
" ----------------------------------

set autoindent
set cindent
set smartindent
set smarttab
set expandtab
set tabstop=4
set softtabstop=0
set shiftwidth=4
set shiftround

" ----------------------------------
" searching
" ----------------------------------

set hlsearch
set incsearch
set ignorecase
set smartcase

" ----------------------------------
" cpu, memory
" ----------------------------------

set hidden
set history=100
set lazyredraw
set synmaxcol=240
set updatetime=700

" ----------------------------------
" keymaps
" ----------------------------------

let mapleader=','

nmap <C-t> :term<CR>
nmap <C-d> :bd!<CR>
nmap <C-q> :qa!<CR>
nmap <C-s> :w<CR>
imap <C-s> <C-c>:w<CR>
nmap <leader>h :nohl<CR>

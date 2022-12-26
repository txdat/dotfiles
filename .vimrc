" ----------------------------------
" general
" ----------------------------------

syntax on
filetype plugin indent on

set clipboard=unnamed,unnamedplus
set timeoutlen=500  " key mappings timeout
set noswapfile
set nobackup
set nowritebackup
set completeopt=menuone,noinsert,noselect
set encoding=utf-8
set fileencoding=utf-8
set mouse=a
set noerrorbells
set bs=2  " backspace

" ----------------------------------
" gui
" ----------------------------------

set bg=dark
set shortmess=I  " disable vim intro
set laststatus=3
set termguicolors
set cursorline
hi CursorLine cterm=none
hi LineNR cterm=none guifg=grey
hi CursorLineNR cterm=bold
set guicursor=n-v-c:block-Cursor
set guicursor+=i:block-iCursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkon0
set ruler
set number
set relativenumber
set showmatch
set foldmethod=marker
set splitright
set splitbelow

" fix tmux colorscheme issue
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" windows gvim
if has('win32') && has('gui_running')
    set guifont=JetbrainsMono:h12
    colorscheme torte
endif

" ----------------------------------
" tabs, indent, ...
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
set linebreak
set textwidth=0

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
set updatetime=250

" ----------------------------------
" keymaps
" ----------------------------------

let mapleader=','

nnoremap <C-t> :term<CR>
nnoremap <Esc> <C-\\><C-n>
nnoremap <C-[> :bprevious<CR>
nnoremap <C-]> :bnext<CR>
nnoremap <C-d> :bd!<CR>
nnoremap <C-q> :<C-U>bprevious <bar> bdelete #<CR>
nnoremap <C-Q> :qa!<CR>
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
nnoremap <leader>h :nohl<CR>
nnoremap <C-s> :w<CR>
inoremap <C-s> <C-c>:w<CR>

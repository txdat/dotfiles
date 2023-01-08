" disable built-in plugins
let built_in_plugins = [
    \'2html_plugin',
    \'getscript',
    \'getscriptPlugin',
    \'gzip',
    \'logipat',
    \'netrw',
    \'netrwPlugin',
    \'netrwSettings',
    \'netrwFileHandlers',
    \'matchit',
    \'tar',
    \'tarPlugin',
    \'rrhelper',
    \'spellfile_plugin',
    \'vimball',
    \'vimballPlugin',
    \'zip',
    \'zipPlugin',
    \'tutor',
    \'rplugin',
    \'synmenu',
    \'optwin',
    \'compiler',
    \'bugreport',
    \'ftplugin',
    \]

for plugin in built_in_plugins
    exe 'let g:loaded_' . plugin . '=1'
endfor

" ----------------------------------
" general
" ----------------------------------

syntax on
filetype plugin indent on

set clipboard=unnamed,unnamedplus  " system's clipboard
set timeoutlen=500  " key mappings timeout
set noswapfile
set nobackup
set nowritebackup
set completeopt=menuone,noinsert,noselect  " insert mode
set encoding=utf-8
set fileencoding=utf-8
set mouse=a  " enable mouse support
set noerrorbells
set bs=2  " fix backspace
let mapleader='/'  " set <leader>

" ----------------------------------
" gui
" ----------------------------------

set background=dark
set shortmess=I  " disable vim intro
set laststatus=3  " set global statusline
set termguicolors  " enable 24bits colors
set guicursor=n-v-c:block-Cursor  " using block cursor
set guicursor+=i:block-iCursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkon0
set ruler  " show cursor position
"set list  " show eol, ...
set cursorline
hi CursorLine cterm=none
hi LineNR cterm=none guifg=grey
hi CursorLineNR cterm=bold
set number  " show line number
set relativenumber  " (-1,+1) line number
set showmatch  " highlight matching parenthesis
set foldmethod=marker  " enable folding
set splitright  " vertical split to the right
set splitbelow  " horizontal split to the bottom

" fix tmux colorscheme issue
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

if has('gui_running')
    set guifont=Jetbrains\ Mono:h10
    colorscheme torte
endif

" ----------------------------------
" tabs, indent, ...
" ----------------------------------

set autoindent
set cindent
set smartindent
set smarttab
set expandtab  " use spaces instead of tab
set tabstop=4  " 1 tab = 4 spaces
set softtabstop=0
set shiftwidth=4  " shifts 4 spaces when using tab
set shiftround
set linebreak  " wrap on word boundary
set textwidth=0

" ----------------------------------
" searching
" ----------------------------------

set hlsearch  " highlight search result
set incsearch  " show first match when start typing
set ignorecase  " ignore case sensitive when searching
set smartcase  " ignore lowercase for the whole pattern

" ----------------------------------
" cpu, memory
" ----------------------------------

set hidden  " enable background buffers
set history=100  " n lines in history
set lazyredraw  " faster scrolling
set synmaxcol=240  " maximum column for syntax highligh
set updatetime=250  " milli-seconds to wait for trigger an event (keymap)

" ----------------------------------
" autocommand functions
" ----------------------------------

" highlight on yank (selected copy)
function s:matchdelete(match, win)
    silent! call matchdelete(a:match, a:win)
endfunction

function! s:FlashYankedText()
    let match = matchadd('Visual', ".\\%>'\\[\\_.*\\%<']..")
    let win = win_getid()
    call timer_start(500, {-> s:matchdelete(match, win)})
endfunction

augroup YankHighlight
    autocmd!
    autocmd TextYankPost * if v:event.operator == 'y' | call s:FlashYankedText() | endif
augroup END

" remove whitespace on save
autocmd BufWritePre * :%s/\\s\\+$//e

" don't auto commenting new lines
autocmd BufEnter * set fo-=c fo-=r fo-=o

" terminal config ----------------------

" open terminal
autocmd CmdlineEnter term :botright split term://$SHELL

" enter insert mode when switching to terminal
autocmd BufWinEnter if &buftype == 'terminal' | setlocal listchars= nonumber norelativenumber nocursorline | endif

autocmd BufWinEnter * if &buftype == 'terminal' | startinsert | endif

" close terminal buffer on process exit
autocmd BufLeave * stopinsert

" ----------------------------------
" keymaps
" ----------------------------------

nnoremap <C-t> :term<CR>
nnoremap <Esc> <C-\\><C-n>

nnoremap <C-[> :bprevious<CR>
nnoremap <C-]> :bnext<CR>

nnoremap <C-d> :bd!<CR>
nnoremap <C-q> :<C-U>bprevious <bar> bdelete #<CR>
nnoremap <C-Q> :qa!<CR>

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

nnoremap <leader>nh :nohl<CR>

nnoremap <C-s> :w<CR>
inoremap <C-s> <C-c>:w<CR>

nnoremap <leader>ql :call setqflist([])<CR>


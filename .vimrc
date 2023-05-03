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

set clipboard^=unnamed,unnamedplus " system's clipboard
set timeout
set timeoutlen=500 " key mappings timeout
set noswapfile
set nobackup
set nowritebackup
set completeopt=menu,menuone,noinsert,noselect " insert mode
set encoding=utf-8
set fileencoding=utf-8
set mouse=a " enable mouse support
set noerrorbells
set bs=2 " fix backspace
let mapleader=' '
" let mapleader='\'

" spelling
set spelllang=en_us
" set spell

" ----------------------------------
" gui
" ----------------------------------

set background="dark"
set shortmess=I " disable vim intro
set laststatus=3 " set global statusline
set guicursor=n-v-c:block-Cursor " using block cursor
set guicursor+=i:block-iCursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkon0
set colorcolumn=80
set ruler " show cursor position
set listchars=eol:↴
set list " show eol, ...
set cursorline
hi CursorLine cterm=none
hi LineNR cterm=none guifg=dimgray
hi CursorLineNR cterm=bold guifg=orange
hi! link Folded Normal
set number " show line number
set relativenumber " (-1,+1) line number
set showmatch " highlight matching parenthesis
set foldmethod=marker " enable folding
set splitright " vertical split to the right
set splitbelow " horizontal split to the bottom

if exists('+termguicolors')
    let &t_8f ="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b ="\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors " enable 24bits colors
endif

" ----------------------------------
" tabs, indent, ...
" ----------------------------------

set autoindent
set cindent
set smartindent
set smarttab
set expandtab " use spaces instead of tab
set tabstop=4 " 1 tab = 4 spaces
set softtabstop=0
set shiftwidth=4 " shifts 4 spaces when using tab
set shiftround
set linebreak " wrap on word boundary
set textwidth=0

" ----------------------------------
" searching
" ----------------------------------

set hlsearch " highlight search result
set incsearch " show first match when start typing
set ignorecase " ignore case sensitive when searching
set smartcase " ignore lowercase for the whole pattern

" ----------------------------------
" cpu, memory
" ----------------------------------

set hidden " enable background buffers
set history=100 " n lines in history
set lazyredraw " faster scrolling
set synmaxcol=240 " maximum column for syntax highligh
set updatetime=250 " milli-seconds to wait for trigger an event (keymap)

" ----------------------------------
" autocommand functions
" ----------------------------------

" highlight on yank (selected copy)
function s:matchdelete(match, win)
    silent! call matchdelete(a:match, a:win)
endfunction

function! s:FlashYankedText()
    let match = matchadd('Visual',".\\%>'\\[\\_.*\\%<']..")
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

" open terminal
autocmd CmdlineEnter term :botright split term://$SHELL

" enter insert mode when switching to terminal
autocmd BufWinEnter if &buftype == 'terminal' | setlocal listchars= nonumber norelativenumber nocursorline | endif

" close terminal buffer on process exit
autocmd BufLeave * stopinsert

" ----------------------------------
" keymaps
" ----------------------------------

nnoremap <silent> <ESC> <nop>

nnoremap <silent> <leader>q q
nnoremap <silent> q <nop>

nnoremap <silent> <F1> :setlocal spell! spell?<CR>
" nnoremap <silent> <C-l> [s1z=<C-o>
" inoremap <silent> <C-l> <C-g>u<ESC>[s1z=`]a<C-g>u

nnoremap <silent> H ^
nnoremap <silent> L $

nnoremap <silent> <C-t> :term<CR>
"tnoremap <silent> <Esc> <C-\><C-n>

nnoremap <silent> <C-[> :bprevious<CR>
nnoremap <silent> <C-]> :bnext<CR>
nnoremap <silent> <C-\> :b#<CR>

nnoremap <silent> <C-d> :bd!<CR>
"nnoremap <silent> <C-S-d> :<C-U>bprevious <bar> bdelete #<CR>
nnoremap <silent> <C-q> :qa!<CR>

nnoremap <silent> <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

nnoremap <silent> <leader>h :nohl<CR>

nnoremap <silent> <C-s> :w<CR>
inoremap <silent> <C-s> <cmd>w<CR>
"inoremap <silent> <C-s> <C-c>:w<CR>
"nnoremap <silent> <C-S-s> :wa<CR>

nnoremap <silent> <leader>co :copen<CR>
nnoremap <silent> <leader>cw :cclose<CR>
nnoremap <silent> <leader>cc :call setqflist([])<CR>

xnoremap <silent> J :move '>+1<CR>gv-gv
xnoremap <silent> K :move '<-2<CR>gv-gv
xnoremap <silent> <A-j> :move '>+1<CR>gv-gv
xnoremap <silent> <A-k> :move '<-2<CR>gv-gv

" ----------------------------------
" colorscheme
" ----------------------------------

" Dark Vim/Neovim color scheme.
"
" URL:     github.com/bluz71/vim-moonfly-colors
" License: MIT (https://opensource.org/licenses/MIT)

" if has('nvim') && !has('nvim-0.8')
"     lua vim.api.nvim_echo({
"         \ { "moonfly requires Neovim 0.8 or later.\n", "WarningMsg" },
"         \ { "Please use the moonfly 'legacy' branch if you can't upgrade Neovim.\n", "Normal"} },
"         \ false, {})
"     finish
" endif

" Clear highlights and reset syntax.
highlight clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name='moonfly'

" Enable terminal true-color support.
set termguicolors

" let g:moonflyCursorColor = get(g:, 'moonflyCursorColor', v:false)
" let g:moonflyItalics = get(g:, 'moonflyItalics', v:true)
" let g:moonflyNormalFloat = get(g:, 'moonflyNormalFloat', v:false)
" let g:moonflyTerminalColors = get(g:, 'moonflyTerminalColors', v:true)
" let g:moonflyTransparent = get(g:, 'moonflyTransparent', v:false)
" let g:moonflyUndercurls = get(g:, 'moonflyUndercurls', v:true)
" let g:moonflyUnderlineMatchParen = get(g:, 'moonflyUnderlineMatchParen', v:false)
" let g:moonflyVirtualTextColor =  get(g:, 'moonflyVirtualTextColor', v:false)
" let g:moonflyWinSeparator = get(g:, 'moonflyWinSeparator', 1)

let g:moonflyCursorColor = v:false
let g:moonflyItalics = v:false
let g:moonflyNormalFloat = v:true
let g:moonflyTerminalColors = v:true
let g:moonflyTransparent = v:false
let g:moonflyUndercurls = v:true
let g:moonflyUnderlineMatchParen = v:false
let g:moonflyVirtualTextColor = v:true
let g:moonflyWinSeparator = 0

" if has('nvim')
"     lua require("moonfly").style()
" else
"     call moonfly#Style()
" end
call moonfly#Style()

" moonfly is a dark theme. Note, set this at the end for startup performance
" reasons.
set background=dark

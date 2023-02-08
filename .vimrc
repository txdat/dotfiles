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

set clipboard=unnamed,unnamedplus " system's clipboard
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
let mapleader='\' " set <leader>

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
set ruler " show cursor position
"set list " show eol, ...
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

if has('gui_running')
    set guicursor& " reset to default
    set guifont=Jetbrains\ Mono:h10
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

nnoremap <silent> <leader>q q
nnoremap <silent> q <nop>

nnoremap <silent> <F1> <nop>

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
inoremap <silent> <C-s> <C-c>:w<CR>
"nnoremap <silent> <C-S-s> :wa<CR>

nnoremap <silent> <leader>co :copen<CR>
nnoremap <silent> <leader>cw :cclose<CR>
nnoremap <silent> <leader>cc :call setqflist([])<CR>

xnoremap <silent> J :move '>+1<CR>gv-gv
xnoremap <silent> K :move '<-2<CR>gv-gv
xnoremap <silent> <A-j> :move '>+1<CR>gv-gv
xnoremap <silent> <A-k> :move '<-2<CR>gv-gv

" compile and run *.cpp
nnoremap <silent> <leader>r :!g++ -std=c++20 -DDEBUG -g % && ./a.out<CR>

" ----------------------------------
" colorscheme
" ----------------------------------

" If you are distributing this theme, please replace this comment
" with the appropriate license attributing the original VS Code
" theme author.

" Kanagawa - A nice dark theme

" ==========> Reset
set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = 'kanagawa'

" ==========> Highlight function
function! s:h(face, guibg, guifg, ctermbg, ctermfg, gui)
  let l:cmd="highlight " . a:face

  if a:guibg != ""
    let l:cmd = l:cmd . " guibg=" . a:guibg
  endif

  if a:guifg != ""
    let l:cmd = l:cmd . " guifg=" . a:guifg
  endif

  if a:ctermbg != ""
    let l:cmd = l:cmd . " ctermbg=" . a:ctermbg
  endif

  if a:ctermfg != ""
    let l:cmd = l:cmd . " ctermfg=" . a:ctermfg
  endif

  if a:gui != ""
    let l:cmd = l:cmd . " gui=" . a:gui
  endif

  exec l:cmd
endfun

" ==========> Colors dictionary

" GUI colors dictionary (hex)
let s:hex = {}
" Terminal colors dictionary (256)
let s:bit = {}

let s:hex.color0="#0F111B"
let s:hex.color1="#ECF0C1"
let s:hex.color2="#DCD7BA"
let s:hex.color3="#223249"
let s:hex.color4="#191b25"
let s:hex.color5="#41434d"
let s:hex.color6="#23252f"
let s:hex.color7="#555761"
let s:hex.color8="#2a2a31"
let s:hex.color9="#dcd4a7"
let s:hex.color10="#43434a"
let s:hex.color11="#f5edc0"
let s:hex.color12="#5a5c66"
let s:hex.color13="#6a88c4"
let s:hex.color14="#2d2f39"
let s:hex.color15="#ffffdf"
let s:hex.color16="#f6facb"
let s:hex.color17="#32343e"
let s:hex.color18="#727169"
let s:hex.color19="#7FB4CA"
let s:hex.color20="#7E9CD8"
let s:hex.color21="#C0A36E"
let s:hex.color22="#98BB6C"
let s:hex.color23="#D27E99"

let s:bit.color8="59"
let s:bit.color9="68"
let s:bit.color15="107"
let s:bit.color13="110"
let s:bit.color14="143"
let s:bit.color16="174"
let s:bit.color2="187"
let s:bit.color1="229"
let s:bit.color10="230"
let s:bit.color0="233"
let s:bit.color4="234"
let s:bit.color6="235"
let s:bit.color3="236"
let s:bit.color11="237"
let s:bit.color5="238"
let s:bit.color7="240"
let s:bit.color12="242"

" ==========> General highlights
call s:h("Normal", s:hex.color0, s:hex.color1, s:bit.color0, s:bit.color1, "none")
call s:h("Cursor", s:hex.color2, s:hex.color2, s:bit.color2, s:bit.color2, "none")
call s:h("Visual", s:hex.color3, "", s:bit.color3, "", "none")
call s:h("ColorColumn", s:hex.color4, "", s:bit.color4, "", "none")
call s:h("LineNr", "", s:hex.color5, "", s:bit.color5, "none")
call s:h("CursorLine", s:hex.color6, "", s:bit.color6, "", "none")
call s:h("CursorLineNr", "", s:hex.color7, "", s:bit.color7, "none")
call s:h("CursorColumn", s:hex.color6, "", s:bit.color6, "", "none")
call s:h("StatusLineNC", s:hex.color8, s:hex.color9, s:bit.color3, s:bit.color2, "none")
call s:h("StatusLine", s:hex.color10, s:hex.color11, s:bit.color5, s:bit.color1, "none")
call s:h("VertSplit", "", s:hex.color12, "", s:bit.color8, "none")
call s:h("Folded", s:hex.color6, s:hex.color13, s:bit.color6, s:bit.color9, "none")
call s:h("Pmenu", s:hex.color14, s:hex.color15, s:bit.color3, s:bit.color10, "none")
call s:h("PmenuSel", s:hex.color4, s:hex.color16, s:bit.color4, s:bit.color10, "none")
call s:h("EndOfBuffer", s:hex.color0, s:hex.color17, s:bit.color0, s:bit.color11, "none")
call s:h("NonText", s:hex.color0, s:hex.color17, s:bit.color0, s:bit.color11, "none")

" ==========> Syntax highlights
call s:h("Comment", "", s:hex.color18, "", s:bit.color12, "none")
call s:h("Constant", "", s:hex.color19, "", s:bit.color13, "none")
call s:h("Special", "", s:hex.color19, "", s:bit.color13, "none")
call s:h("Identifier", "", s:hex.color2, "", s:bit.color2, "none")
call s:h("Function", "", s:hex.color20, "", s:bit.color13, "none")
call s:h("Operator", "", s:hex.color21, "", s:bit.color14, "none")
call s:h("String", "", s:hex.color22, "", s:bit.color15, "none")
call s:h("Number", "", s:hex.color23, "", s:bit.color16, "none")

highlight link cStatement Statement
highlight link cSpecial Special

" Generated using https://github.com/nice/themeforge
" Feel free to remove the above URL and this line.

" fix highlight
hi CursorLine cterm=none
hi LineNR cterm=none guifg=dimgray
hi CursorLineNR cterm=bold guifg=orange

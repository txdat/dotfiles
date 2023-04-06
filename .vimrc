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
" let mapleader=' '
let mapleader='\'

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

if has('gui_running')
    set guicursor& " reset to default
    set guifont=JetbrainsMono\ Nerd\ Font\ Mono:h10
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
nnoremap <silent> <F7> :setlocal spell! spell?<CR>

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

" If you are distributing this theme, please replace this comment
" with the appropriate license attributing the original VS Code
" theme author.

" Tokyo Night - A nice dark theme

" ==========> Reset
set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = 'tokyo-night'

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

let s:hex.color0="#1a1b26"
let s:hex.color1="#a9b1d6"
let s:hex.color2="#c0caf5"
let s:hex.color3="#474853"
let s:hex.color4="#242530"
let s:hex.color5="#4c4d58"
let s:hex.color6="#2e2f3a"
let s:hex.color7="#60616c"
let s:hex.color8="#2a2a32"
let s:hex.color9="#8c90ad"
let s:hex.color10="#43434b"
let s:hex.color11="#a5a9c6"
let s:hex.color12="#656671"
let s:hex.color13="#668ee3"
let s:hex.color14="#383944"
let s:hex.color15="#c7cff4"
let s:hex.color16="#b3bbe0"
let s:hex.color17="#3d3e49"
let s:hex.color18="#444b6a"
let s:hex.color19="#ff9e64"
let s:hex.color20="#7aa2f7"
let s:hex.color21="#bb9af7"
let s:hex.color22="#89ddff"
let s:hex.color23="#9ece6a"

let s:bit.color10="68"
let s:bit.color7="103"
let s:bit.color15="111"
let s:bit.color17="117"
let s:bit.color16="141"
let s:bit.color1="146"
let s:bit.color18="149"
let s:bit.color2="153"
let s:bit.color12="189"
let s:bit.color14="215"
let s:bit.color0="234"
let s:bit.color4="235"
let s:bit.color5="236"
let s:bit.color11="237"
let s:bit.color8="238"
let s:bit.color3="239"
let s:bit.color13="240"
let s:bit.color6="241"
let s:bit.color9="242"

" ==========> General highlights
call s:h("Normal", s:hex.color0, s:hex.color1, s:bit.color0, s:bit.color1, "none")
call s:h("Cursor", s:hex.color2, "", s:bit.color2, "", "none")
call s:h("Visual", s:hex.color3, "", s:bit.color3, "", "none")
call s:h("ColorColumn", s:hex.color4, "", s:bit.color4, "", "none")
call s:h("LineNr", "", s:hex.color5, "", s:bit.color3, "none")
call s:h("CursorLine", s:hex.color6, "", s:bit.color5, "", "none")
call s:h("CursorLineNr", "", s:hex.color7, "", s:bit.color6, "none")
call s:h("CursorColumn", s:hex.color6, "", s:bit.color5, "", "none")
call s:h("StatusLineNC", s:hex.color8, s:hex.color9, s:bit.color5, s:bit.color7, "none")
call s:h("StatusLine", s:hex.color10, s:hex.color11, s:bit.color8, s:bit.color1, "none")
call s:h("VertSplit", "", s:hex.color12, "", s:bit.color9, "none")
call s:h("Folded", s:hex.color6, s:hex.color13, s:bit.color5, s:bit.color10, "none")
call s:h("Pmenu", s:hex.color14, s:hex.color15, s:bit.color11, s:bit.color12, "none")
call s:h("PmenuSel", s:hex.color4, s:hex.color16, s:bit.color4, s:bit.color1, "none")
call s:h("EndOfBuffer", s:hex.color0, s:hex.color17, s:bit.color0, s:bit.color8, "none")
call s:h("NonText", s:hex.color0, s:hex.color17, s:bit.color0, s:bit.color8, "none")

" ==========> Syntax highlights
call s:h("Comment", "", s:hex.color18, "", s:bit.color13, "none")
call s:h("Constant", "", s:hex.color19, "", s:bit.color14, "none")
call s:h("Special", "", s:hex.color19, "", s:bit.color14, "none")
call s:h("Identifier", "", s:hex.color2, "", s:bit.color2, "none")
call s:h("Function", "", s:hex.color20, "", s:bit.color15, "none")
call s:h("Statement", "", s:hex.color21, "", s:bit.color16, "none")
call s:h("Operator", "", s:hex.color22, "", s:bit.color17, "none")
call s:h("PreProc", "", s:hex.color21, "", s:bit.color16, "none")
call s:h("Type", "", s:hex.color21, "", s:bit.color16, "none")
call s:h("String", "", s:hex.color23, "", s:bit.color18, "none")
call s:h("Number", "", s:hex.color19, "", s:bit.color14, "none")

highlight link cStatement Statement
highlight link cSpecial Special

" Generated using https://github.com/nice/themeforge
" Feel free to remove the above URL and this line.

" fix highlight
hi CursorLine cterm=none
hi LineNR cterm=none guifg=dimgray
hi CursorLineNR cterm=bold guifg=orange

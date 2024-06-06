" vim
" config{{{
" disable builtin plugins
let builtin_plugins = [
    \'tutor',
    \'tohtml',
    \'2html_plugin',
    \'getscript',
    \'getscriptPlugin',
    \'gzip',
    \'zipPlugin',
    \'logipat',
    \'netrw',
    \'netrwPlugin',
    \'netrwSettings',
    \'netrwFileHandlers',
    \'matchit',
    \'matchparen',
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

for plugin in builtin_plugins
    exe 'let g:loaded_' . plugin . '=1'
endfor

" ----------------------------------
" general
" ----------------------------------

set rtp^=~/.vim
set nocompatible " use vim defaults
" set clipboard^=unnamed,unnamedplus " system's clipboard
set timeout
set timeoutlen=300 " key mappings timeout
set noswapfile
set nobackup
set nowritebackup
set completeopt=menu,menuone,noinsert,noselect " insert mode
set encoding=utf-8
set fileencoding=utf-8
set mouse=a " enable mouse support
set noerrorbells
set belloff=all
set bs=2 " backspacing in insert mode
set modelines=2
set wildmode=longest,list
set shortmess=I " disable vim intro
set laststatus=2 " always show statusline
set guicursor=n-v-c:block-Cursor " using block cursor
set guicursor+=i:block-iCursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkon0
" set colorcolumn=80
set ruler " show cursor position
" set listchars=eol:↴
" set list " show eol, ...
set cursorline
set number " show line number
set relativenumber " (-1,+1) line number
set showmatch " highlight matching parenthesis
set foldmethod=marker " enable folding
set splitright " vertical split to the right
set splitbelow " horizontal split to the bottom

let mapleader=' '
let maplocalleader='\'

" spelling
" set spelllang=en_us
" set spell

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
set viminfo='20,\"50
set history=50
set lazyredraw " faster scrolling
set synmaxcol=240 " maximum column for syntax highligh
set updatetime=100 " milli-seconds to wait for trigger an event (keymap)

" ----------------------------------
" statusline
" ----------------------------------

" set noshowmode
set statusline=
set statusline+=%1*\ [%{toupper(mode())}]\  " The current mode
set statusline+=%2*\ %<%f%m%r%h%w\          " File path, modified, readonly, helpfile, preview
set statusline+=%=                          " Right Side
set statusline+=%1*\ %l:%v\ %3p%%           " Line:Col number, percentage of document
" set statusline+=%2*\ %{''.(&fenc!=''?&fenc:&enc).''}     " Encoding
" set statusline+=%3*\ (%{&ff})                            " FileFormat (dos/unix..)

" ----------------------------------
" autocommands
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
" user commands
" ----------------------------------

command! -nargs=1 SetIndent execute printf("set tabstop=%s softtabstop=%s shiftwidth=%s", <args>, <args>, <args>)

command! -nargs=+ QfReplace call QfReplace(<f-args>)
function! QfReplace(...)
    execute printf('cfdo %%s/%s/%s/%s', a:1, a:2, get(a:,3,'c | up'))
    execute 'cfdo update'
endfunction

" ----------------------------------
" colorscheme
" ----------------------------------

syntax on
filetype plugin indent on
"let &t_8f ="\<Esc>[38;2;%lu;%lu;%lum"
"let &t_8b ="\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors " enable 24bits colors

let g:moonflyCursorColor = v:false
let g:moonflyItalics = v:false
let g:moonflyNormalFloat = v:true
let g:moonflyTerminalColors = v:true
let g:moonflyTransparent = v:false
let g:moonflyUndercurls = v:false
let g:moonflyUnderlineMatchParen = v:false
let g:moonflyVirtualTextColor =  v:true
let g:moonflyWinSeparator = 0
call moonfly#Style()

set background="dark"
"}}}

" keymaps{{{

" nnoremap <silent> <ESC> <nop>
" inoremap <silent> jj <ESC>

nnoremap <silent> <A-q> q
nnoremap <silent> q <nop>

inoremap <silent> <F1> <nop>
nnoremap <silent> <F1> :set wrap!<CR>

nnoremap <silent> <F2> :set invpaste paste?<CR>
"set pastetoggle=<F2>

nnoremap <silent> <F3> :setlocal spell! spell?<CR>
" nnoremap <silent> <C-l> [s1z=<C-o>
" inoremap <silent> <C-l> <C-g>u<ESC>[s1z=`]a<C-g>u

nnoremap <silent> DD "_dd

nnoremap <silent> H ^
nnoremap <silent> L $
nnoremap <silent> J <C-d>
nnoremap <silent> K <C-u>

nnoremap <silent> <A-v> :vsplit<CR>

nnoremap <silent> <C-t> :term<CR>
"tnoremap <silent> <Esc> <C-\><C-n>

nnoremap <silent> [t :gT<CR>
nnoremap <silent> ]t :gt<CR>
nnoremap <silent> \t :tablast<CR>

nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> \b :b#<CR>

nnoremap <silent> <C-u> <nop>
nnoremap <silent> <C-d> :bd!<CR>
"nnoremap <silent> <C-S-d> :<C-U>bprevious <bar> bdelete #<CR>
nnoremap <silent> <C-q> :qa!<CR>

nnoremap <silent> <ESC> :nohl<CR>

nnoremap <silent> <C-s> :w<CR>
inoremap <silent> <C-s> <cmd>w<CR>
"inoremap <silent> <C-s> <C-c>:w<CR>
"nnoremap <silent> <C-S-s> :wa<CR>

nnoremap <silent> qo :copen<CR>
nnoremap <silent> qq :cclose<CR>
nnoremap <silent> qc :call setqflist([])<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprev<CR>

vnoremap <silent> // y/\V<C-R>=escape(@",'/\')<CR><CR>
tnoremap <silent> <expr> <C-r> '<C-\><C-N>"'.nr2char(getchar()).'pi' " TODO

" xnoremap <silent> J :move '>+1<CR>gv-gv
" xnoremap <silent> K :move '<-2<CR>gv-gv

nnoremap <silent> <F12> :!g++ -g % && ./a.out<CR>
"}}}

" plugins{{{
call plug#begin()

Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'

" fzf{{{
Plug 'junegunn/fzf.vim'

let g:fzf_vim = {}
"let g:fzf_vim.command_prefix = 'Fzf'
let g:fzf_layout = { 'window': { 'width': 1.0, 'height': 1.0, 'relative': v:true } }

" overwrite fzf's functions
command! -bang -nargs=* Files call fzf#run(fzf#wrap(
  \   'fd
        \ --type f
        \ --color=always
        \ --hidden
        \ --follow
        \ --exclude .git
        \ '.shellescape(<q-args>),
  \   fzf#vim#with_preview(),
  \   <bang>0))

command! -bang -nargs=* Rg call fzf#vim#grep(
  \   'rg
        \ --color=always
        \ --hidden
        \ --follow
        \ --no-heading
        \ --with-filename
        \ --line-number
        \ --column
        \ --smart-case
        \ --glob "!.git/*"
        \ '.shellescape(<q-args>),
  \   fzf#vim#with_preview(),
  \   <bang>0)

nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>fg :Rg<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
"}}}

call plug#end()
"}}}

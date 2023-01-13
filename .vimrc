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
"colorscheme spaceduck
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
hi LineNR cterm=none guifg=grey
hi CursorLineNR cterm=bold
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
nnoremap <C-S-D> :<C-U>bprevious <bar> bdelete #<CR>
nnoremap <C-q> :qa!<CR>

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

nnoremap <leader>h :nohl<CR>

nnoremap <C-s> :w<CR>
inoremap <C-s> <C-c>:w<CR>

nnoremap <leader>co :copen<CR>
nnoremap <leader>cw :cclose<CR>
nnoremap <leader>cc :call setqflist([])<CR>

" ----------------------------------
" colorscheme
" ----------------------------------

" ===============================================================
" spaceduck
"
" URL: https://github.com/pineapplegiant/spaceduck
" Author: Guillermo Rodriguez
" License: MIT
" Last Change: 2021/03/16 22:28
" ===============================================================

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name="spaceduck"

let Italic = ""
if exists('g:spaceduck_italic')
  let Italic = "italic"
endif
let g:spaceduck_italic = get(g:, 'spaceduck_italic', 0)

let Bold = ""
if exists('g:spaceduck_bold')
  let Bold = "bold"
endif

let g:spaceduck_bold = get(g:, 'spaceduck_bold', 0)
hi ColorColumn guifg=NONE ctermfg=NONE guibg=#16172d ctermbg=234 gui=NONE cterm=NONE
hi CursorColumn guifg=NONE ctermfg=NONE guibg=#16172d ctermbg=234 gui=NONE cterm=NONE
hi Conceal guifg=#686f9a ctermfg=60 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Cursor guifg=#0f111b ctermfg=233 guibg=#818596 ctermbg=102 gui=NONE cterm=NONE
hi link CursorIM Cursor
hi CursorLine guifg=NONE ctermfg=NONE guibg=#16172d ctermbg=234 gui=NONE cterm=NONE
hi CursorLineNr guifg=#c1c3cc ctermfg=251 guibg=#16172d ctermbg=234 gui=NONE cterm=NONE
hi Directory guifg=#00a3cc ctermfg=38 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiffAdd guifg=#5ccc96 ctermfg=78 guibg=#1b1c36 ctermbg=234 gui=NONE cterm=NONE
hi DiffChange guifg=#e39400 ctermfg=172 guibg=#1b1c36 ctermbg=234 gui=NONE cterm=NONE
hi DiffDelete guifg=#e33400 ctermfg=166 guibg=#1b1c36 ctermbg=234 gui=NONE cterm=NONE
hi DiffText guifg=#f2ce00 ctermfg=220 guibg=#1b1c36 ctermbg=234 gui=NONE cterm=NONE
hi EndOfBuffer guifg=#30365F ctermfg=237 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi link TermCursor Cursor
hi ErrorMsg guifg=#e33400 ctermfg=166 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi VertSplit guifg=#000000 ctermfg=0 guibg=#000000 ctermbg=0 gui=NONE cterm=NONE
hi Folded guifg=#686f9a ctermfg=60 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi FoldColumn guifg=#30365F ctermfg=237 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi SignColumn guifg=#30365F ctermfg=237 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi IncSearch guifg=#ffffff ctermfg=15 guibg=#30365F ctermbg=237 gui=NONE cterm=NONE
hi LineNr guifg=#30365F ctermfg=237 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi MatchParen guifg=#ffffff ctermfg=15 guibg=#30365F ctermbg=237 gui=NONE cterm=NONE
hi ModeMsg guifg=#b3a1e6 ctermfg=146 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi MoreMsg guifg=#b3a1e6 ctermfg=146 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi link NonText EndOfBuffer
hi Pmenu guifg=#ecf0c1 ctermfg=255 guibg=#1b1c36 ctermbg=234 gui=NONE cterm=NONE
hi PmenuSel guifg=#ffffff ctermfg=15 guibg=#30365F ctermbg=237 gui=NONE cterm=NONE
hi PmenuSbar guifg=NONE ctermfg=NONE guibg=#30365F ctermbg=237 gui=NONE cterm=NONE
hi PmenuThumb guifg=NONE ctermfg=NONE guibg=#686f9a ctermbg=60 gui=NONE cterm=NONE
hi Question guifg=#b3a1e6 ctermfg=146 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi QuickFixLine guifg=#ecf0c1 ctermfg=255 guibg=#16172d ctermbg=234 gui=NONE cterm=NONE
hi Search guifg=#ffffff ctermfg=15 guibg=#686f9a ctermbg=60 gui=NONE cterm=NONE
hi SpecialKey guifg=#e39400 ctermfg=172 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi SpellBad guifg=#e33400 ctermfg=166 guibg=NONE ctermbg=NONE gui=underline cterm=underline
hi SpellLocal guifg=#ecf0c1 ctermfg=255 guibg=NONE ctermbg=NONE gui=underline cterm=underline
hi SpellCap guifg=#5ccc96 ctermfg=78 guibg=NONE ctermbg=NONE gui=underline cterm=underline
hi SpellRare guifg=#f2ce00 ctermfg=220 guibg=NONE ctermbg=NONE gui=underline cterm=underline
hi StatusLine guifg=#ecf0c1 ctermfg=255 guibg=#0f111b ctermbg=233 gui=reverse cterm=reverse
hi link StatusLineTerm StatusLine
hi StatusLineTermNC guifg=#000000 ctermfg=0 guibg=#30365F ctermbg=237 gui=reverse cterm=reverse
hi link StatusLineNC StatusLineTermNC
hi TabLine guifg=#000000 ctermfg=0 guibg=#818596 ctermbg=102 gui=NONE cterm=NONE
hi TabLineFill guifg=#818596 ctermfg=102 guibg=#000000 ctermbg=0 gui=NONE cterm=NONE
hi TabLineSel guifg=#c1c3cc ctermfg=251 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi Visual guifg=NONE ctermfg=NONE guibg=#1b1c36 ctermbg=234 gui=NONE cterm=NONE
hi link VisualNOS Visual
hi WarningMsg guifg=#e39400 ctermfg=172 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi WildMenu guifg=#000000 ctermfg=0 guibg=#c1c3cc ctermbg=251 gui=NONE cterm=NONE
hi link Whitespace EndOfBuffer
hi diffAdded guifg=#b3a1e6 ctermfg=146 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi diffRemoved guifg=#e33400 ctermfg=166 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Normal guifg=#ecf0c1 ctermfg=255 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi Comment guifg=#30365F ctermfg=237 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Constant guifg=#f2ce00 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Identifier guifg=#00a3cc ctermfg=38 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Statement guifg=#5ccc96 ctermfg=78 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi PreProc guifg=#b3a1e6 ctermfg=146 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Type guifg=#ce6f8f ctermfg=168 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Special guifg=#b3a1e6 ctermfg=146 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Underlined guifg=#5ccc96 ctermfg=78 guibg=NONE ctermbg=NONE gui=underline cterm=underline
hi Error guifg=#e33400 ctermfg=166 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Ignore guifg=#e33400 ctermfg=166 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Delimiter guifg=#ecf0c1 ctermfg=255 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Operator guifg=#ce6f8f ctermfg=168 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Tag guifg=#b3a1e6 ctermfg=146 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Debug guifg=#b3a1e6 ctermfg=146 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StorageClass guifg=#b3a1e6 ctermfg=146 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi String guifg=#00a3cc ctermfg=38 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Structure guifg=#00a3cc ctermfg=38 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Typedef guifg=#00a3cc ctermfg=38 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Function guifg=#5ccc96 ctermfg=78 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Include guifg=#5ccc96 ctermfg=78 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Label guifg=#5ccc96 ctermfg=78 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Exception guifg=#e39400 ctermfg=172 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Keyword guifg=#e39400 ctermfg=172 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi SpecialChar guifg=#e39400 ctermfg=172 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Boolean guifg=#f2ce00 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Character guifg=#f2ce00 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Float guifg=#f2ce00 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Number guifg=#f2ce00 ctermfg=220 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Conditional guifg=#5ccc96 ctermfg=78 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Repeat guifg=#5ccc96 ctermfg=78 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Title guifg=#7a5ccc ctermfg=98 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Define guifg=#7a5ccc ctermfg=98 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Macro guifg=#7a5ccc ctermfg=98 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi PreCondit guifg=#7a5ccc ctermfg=98 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi link SpecialComment Comment
hi Todo guifg=#ffffff ctermfg=15 guibg=#686f9a ctermbg=60 gui=underline cterm=underline
hi link cFormat Title
hi link cCppOutIf1 Normal
hi link cCppOutIf2 Normal
hi link cBracket Title
hi link cssBraces Normal
hi cssSelectorOp guifg=#ce6f8f ctermfg=168 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi link fortranType Tag
hi link fortranStructure Structure
hi link fortranStorageClass StorageClass
hi link fortranUnitHeader Title
hi link haskellType Tag
hi link haskellIdentifier Label
hi link haskellKeyword Boolean
hi link haskellDecl Boolean
hi link htmlTagName Function
hi link htmlEndTag Conditional
hi link htmlArg Tag
hi link htmlSpecialTagName Type
hi link javaClassDecl Structure
hi link javaTypeDef Keyword
hi link jsStorageClass Title
hi link jsFunction Function
hi link jsFuncName Special
hi link jsOperator Operator
hi link jsNull Constant
hi link jsGlobalObjects Constant
hi link jsFuncCall Function
hi link jsOperatorKeyword Operator
hi link jsExceptions Error
hi link jsObjectProp Tag
hi link jsTernaryIfOperator Title
hi link jsTemplateBraces Title
hi link jsTemplateExpression String
hi link texTypeStyle Special
hi link mkdDelimiter Normal
hi link phpFunction Function
hi link phpMethod Function
hi link phpType Constant
hi link phpIdentifier Type
hi link phpStringSingle String
hi link phpStringDouble String
hi pythonOperator guifg=#ce6f8f ctermfg=168 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi link rubyConstant Constant
hi link rubyDefine Define
hi link rubyMethodName Function
hi link rubyInstanceVariable Tag
hi link rubyKeywordAsMethod Tag
hi link typescriptProp Tag
hi link typescriptVariable Title
hi link jsxTagName HTMLTagName
hi link jsxComponentName Tag
hi link jsxOpenPunct jsxTagName
hi link jsxClosePunct jsxOpenPunct
hi link jsxCloseString jsxClosePunct
hi link typescriptBraces Normal
hi typescriptArrowFunc guifg=#ce6f8f ctermfg=168 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi link typescriptNumberStaticMethod Function
hi link typescriptNumberMethod Function
hi link typescriptStringStaticMethod Function
hi link typescriptStringMethod Function
hi link typescriptArrayStaticMethod Function
hi link typescriptArrayMethod Function
hi link typescriptObjectStaticMethod Function
hi link typescriptObjectMethod Function
hi link typescriptSymbolStaticMethod Function
hi link typescriptFunctionMethod Function
hi link typescriptMathStaticMethod Function
hi link typescriptDateStaticMethod Function
hi link typescriptDateMethod Function
hi link typescriptJSONStaticMethod Function
hi link typescriptRegExpMethod Function
hi link typescriptES6MapMethod Function
hi link typescriptES6SetMethod Function
hi link typescriptPromiseStaticMethod Function
hi link typescriptPromiseMethod Function
hi link typescriptReflectMethod Function
hi link typescriptIntlMethod Function
hi link typescriptBOMNavigatorMethod Function
hi link typescriptServiceWorkerMethod Function
hi link typescriptBOMLocationMethod Function
hi link typescriptBOMHistoryMethod Function
hi link typescriptConsoleMethod Function
hi link typescriptXHRMethod Function
hi link typescriptFileMethod Function
hi link typescriptFileReaderMethod Function
hi link typescriptFileListMethod Function
hi link typescriptBlobMethod Function
hi link typescriptURLStaticMethod Function
hi link typescriptSubtleCryptoMethod Function
hi link typescriptCryptoMethod Function
hi link typescriptHeadersMethod Function
hi link typescriptRequestMethod Function
hi link typescriptResponseMethod Function
hi link typescriptCacheMethod Function
hi link typescriptEncodingMethod Function
hi link typescriptGeolocationMethod Function
hi link typescriptPaymentMethod Function
hi link typescriptPaymentResponseMethod Function
hi link typescriptDOMNodeMethod Function
hi link typescriptDOMDocMethod Function
hi link typescriptDOMEventTargetMethod Function
hi link typescriptDOMEventMethod Function
hi link typescriptDOMStorageMethod Function
hi link typescriptDOMFormMethod Function
hi link vimGroupName Normal
hi link yamlKeyValueDelimiter Normal
hi link yamlBlockMappingKey Function
hi link vistaTag Conditional
hi link vistaIcon Identifier
hi link vistaColon Normal
hi link vistaScope Constant
hi link vistaKind Conditional
hi Sneak guifg=#000000 ctermfg=0 guibg=#f2ce00 ctermbg=220 gui=NONE cterm=NONE
hi BufferCurrent guifg=#c1c3cc ctermfg=251 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi BufferVisible guifg=#30365F ctermfg=237 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi BufferInactive guifg=#30365F ctermfg=237 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi BufferTabpageFill guifg=#0f111b ctermfg=233 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi BufferCurrentIndex guifg=#5ccc96 ctermfg=78 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi BufferVisibleIndex guifg=#30365F ctermfg=237 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi BufferInactiveIndex guifg=#30365F ctermfg=237 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi BufferCurrentMod guifg=#e39400 ctermfg=172 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi BufferVisibleMod guifg=#e39400 ctermfg=172 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi BufferInactiveMod guifg=#e39400 ctermfg=172 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi BufferCurrentSign guifg=#5ccc96 ctermfg=78 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi BufferVisibleSign guifg=#30365F ctermfg=237 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi BufferInactiveSign guifg=#30365F ctermfg=237 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi BufferCurrentTarget guifg=#ce6f8f ctermfg=168 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi BufferVisibleTarget guifg=#ce6f8f ctermfg=168 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE
hi BufferInactiveTarget guifg=#ce6f8f ctermfg=168 guibg=#0f111b ctermbg=233 gui=NONE cterm=NONE

let g:terminal_color_foreground = "#ecf0c1"
let g:terminal_color_background = "#0f111b"
let g:terminal_color_0 = "#000000"
let g:terminal_color_1 = "#e33400"
let g:terminal_color_2 = "#5ccc96"
let g:terminal_color_3 = "#b3a1e6"
let g:terminal_color_4 = "#00a3cc"
let g:terminal_color_5 = "#ce6f8f"
let g:terminal_color_6 = "#7a5ccc"
let g:terminal_color_7 = "#686f9a"
let g:terminal_color_8 = "#686f9a"
let g:terminal_color_9 = "#e33400"
let g:terminal_color_10 = "#5ccc96"
let g:terminal_color_11 = "#b3a1e6"
let g:terminal_color_12 = "#00a3cc"
let g:terminal_color_13 = "#ce6f8f"
let g:terminal_color_14 = "#7a5ccc"
let g:terminal_color_15 = "#ecf0c1"

let g:terminal_ansi_colors =  ["#000000", "#e33400", "#5ccc96", "#b3a1e6", "#00a3cc", "#ce6f8f", "#7a5ccc", "#686f9a", "#686f9a", "#e33400", "#5ccc96", "#b3a1e6", "#00a3cc", "#ce6f8f", "#7a5ccc", "#ecf0c1"]

" ===================================
" Generated by Estilo 1.4.1
" https://github.com/jacoborus/estilo
" ===================================

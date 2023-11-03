" Dark Vim/Neovim color scheme.
"
" URL:     github.com/bluz71/vim-moonfly-colors
" License: MIT (https://opensource.org/licenses/MIT)

" Clear highlights and reset syntax.
highlight clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name='moonfly'

" Enable terminal true-color support.
set termguicolors

let g:moonflyCursorColor = v:false
let g:moonflyItalics = v:false
let g:moonflyNormalFloat = v:true
let g:moonflyTerminalColors = v:true
let g:moonflyTransparent = v:false
let g:moonflyUndercurls = v:true
let g:moonflyUnderlineMatchParen = v:false
let g:moonflyVirtualTextColor =  v:true
let g:moonflyWinSeparator = 0

call moonfly#Style()

" moonfly is a dark theme. Note, set this at the end for startup performance
" reasons.
set background=dark

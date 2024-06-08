highlight clear
"syntax on
syntax reset

let g:colors_name='moonfly'

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

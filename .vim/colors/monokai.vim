" File:       monokai.vim
" Maintainer: Crusoe Xia (crusoexia)
" URL:        https://github.com/crusoexia/vim-monokai
" License:    MIT
"
" The colour palette is from http://www.colourlovers.com/

" Initialization
" --------------

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "monokai"

function! s:h(group, style)
  " let s:ctermformat = "NONE"
  let s:guiformat = "NONE"
  if has_key(a:style, "format")
    " let s:ctermformat = a:style.format
    let s:guiformat = a:style.format
  endif
  " let l:ctermfg = (has_key(a:style, "fg") ? a:style.fg.cterm : "NONE")
  " let l:ctermbg = (has_key(a:style, "bg") ? a:style.bg.cterm : "NONE")
  execute "highlight" a:group
    \ "guifg="   (has_key(a:style, "fg")      ? a:style.fg.gui   : "NONE")
    \ "guibg="   (has_key(a:style, "bg")      ? a:style.bg.gui   : "NONE")
    \ "guisp="   (has_key(a:style, "sp")      ? a:style.sp.gui   : "NONE")
    \ "gui="     (!empty(s:guiformat) ? s:guiformat   : "NONE")
    " \ "ctermfg=" . l:ctermfg
    " \ "ctermbg=" . l:ctermbg
    " \ "cterm="   (!empty(s:ctermformat) ? s:ctermformat   : "NONE")
endfunction

" Palettes
" --------

let s:black0 = { "gui": "#000000" }
let s:white0 = { "gui": "#bdbdbd" }

let s:white       = { "gui": "#E8E8E3" }
let s:white2      = { "gui": "#d8d8d3" }
let s:black       = { "gui": "#272822" }
let s:lightblack  = { "gui": "#2D2E27" }
let s:lightblack2 = { "gui": "#383a3e" }
let s:lightblack3 = { "gui": "#3f4145" }
let s:darkblack   = { "gui": "#211F1C" }
let s:br_grey     = { "gui": "#a1a29c" }
let s:grey        = { "gui": "#8F908A" }
let s:lightgrey   = { "gui": "#575b61" }
let s:darkgrey    = { "gui": "#64645e" }
let s:warmgrey    = { "gui": "#75715E" }

let s:pink        = { "gui": "#F92772" }
let s:green       = { "gui": "#A6E22D" }
let s:aqua        = { "gui": "#66d9ef" }
let s:yellow      = { "gui": "#E6DB74" }
let s:orange      = { "gui": "#FD9720" }
let s:purple      = { "gui": "#ae81ff" }
let s:red         = { "gui": "#e73c50" }
let s:purered     = { "gui": "#ff0000" }
let s:darkred     = { "gui": "#5f0000" }

let s:addfg       = { "gui": "#d7ffaf" }
let s:addbg       = { "gui": "#5f875f" }
let s:delfg       = { "gui": "#ff8b8b" }
let s:delbg       = { "gui": "#f75f5f" }
let s:changefg    = { "gui": "#d7d7ff" }
let s:changebg    = { "gui": "#5f5f87" }

let s:cyan        = { "gui": "#A1EFE4" }
let s:br_green    = { "gui": "#9EC400" }
let s:br_yellow   = { "gui": "#E7C547" }
let s:br_blue     = { "gui": "#7AA6DA" }
let s:br_purple   = { "gui": "#B77EE0" }
let s:br_cyan     = { "gui": "#54CED6" }
let s:br_white    = { "gui": "#FFFFFF" }

" Highlighting
" ------------

" editor
call s:h("Normal",        { "fg": s:white0,     "bg": s:black0 })
call s:h("ColorColumn",   {                     "bg": s:lightblack })
call s:h("Conceal",       { "fg": s:grey })
call s:h("Cursor",        { "fg": s:black,      "bg": s:white })
call s:h("CursorColumn",  {                     "bg": s:lightblack2 })
call s:h("CursorLine",    {                     "bg": s:lightblack2 })
call s:h("NonText",       { "fg": s:lightgrey })
call s:h("Visual",        {                     "bg": s:lightgrey })
call s:h("Search",        { "fg": s:black,      "bg": s:yellow })
call s:h("MatchParen",    { "fg": s:purple,                               "format": "bold" })
call s:h("Question",      { "fg": s:yellow })
call s:h("ModeMsg",       { "fg": s:yellow })
call s:h("MoreMsg",       { "fg": s:yellow })
call s:h("ErrorMsg",      { "fg": s:black,      "bg": s:red,              "format": "standout" })
call s:h("WarningMsg",    { "fg": s:red })
call s:h("VertSplit",     { "fg": s:darkgrey })
call s:h("WinSeparator",  { "fg": s:darkgrey,   "bg": s:darkblack })
call s:h("LineNr",        { "fg": s:grey })
call s:h("CursorLineNr",  { "fg": s:orange,     "bg": s:lightblack })
call s:h("SignColumn",    {                     "bg": s:black0 })

" statusline
call s:h("StatusLine",    { "fg": s:black,      "bg": s:lightgrey })
call s:h("StatusLineNC",  { "fg": s:lightgrey,  "bg": s:darkblack })
call s:h("TabLine",       { "fg": s:lightgrey,  "bg": s:lightblack })
call s:h("TabLineSel",    { "fg": s:darkblack,  "bg": s:warmgrey,         "format": "bold" })
call s:h("TabLineFill",   { "bg": s:lightblack })

" misc
call s:h("SpecialKey",    { "fg": s:pink })
call s:h("Title",         { "fg": s:yellow })
call s:h("Directory",     { "fg": s:aqua })

" diff
call s:h("DiffAdd",       { "fg": s:addfg,      "bg": s:addbg })
call s:h("DiffDelete",    { "fg": s:delfg,      "bg": s:delbg })
call s:h("DiffChange",    { "fg": s:changefg,   "bg": s:changebg })
call s:h("DiffText",      { "fg": s:black,      "bg": s:aqua })

" fold
call s:h("Folded",        { "fg": s:warmgrey,   "bg": s:darkblack })
call s:h("FoldColumn",    {                     "bg": s:black0 })
"        Incsearch"

" popup menu
call s:h("Pmenu",         { "fg": s:white2,     "bg": s:darkblack })
call s:h("PmenuSel",      { "fg": s:aqua,       "bg": s:darkblack,        "format": "reverse,bold" })
call s:h("PmenuThumb",    { "fg": s:lightblack, "bg": s:grey })
"        PmenuSbar"

" floating
call s:h("NormalFloat",   { "fg": s:white2,     "bg": s:darkblack })

" Generic Syntax Highlighting
" ---------------------------

call s:h("Constant",      { "fg": s:purple })
call s:h("Number",        { "fg": s:purple })
call s:h("Float",         { "fg": s:purple })
call s:h("Boolean",       { "fg": s:purple })
call s:h("Character",     { "fg": s:yellow })
call s:h("String",        { "fg": s:yellow })

call s:h("Type",          { "fg": s:aqua })
call s:h("Structure",     { "fg": s:aqua })
call s:h("StorageClass",  { "fg": s:aqua })
call s:h("Typedef",       { "fg": s:aqua })

call s:h("Identifier",    { "fg": s:green })
call s:h("Function",      { "fg": s:green })

call s:h("Statement",     { "fg": s:pink })
call s:h("Operator",      { "fg": s:pink })
call s:h("Label",         { "fg": s:pink })
call s:h("Keyword",       { "fg": s:pink })
"        Conditional"
"        Repeat"
"        Exception"

call s:h("PreProc",       { "fg": s:green })
call s:h("Include",       { "fg": s:pink })
call s:h("Define",        { "fg": s:pink })
call s:h("Macro",         { "fg": s:green })
call s:h("PreCondit",     { "fg": s:green })

call s:h("Special",       { "fg": s:purple })
call s:h("SpecialChar",   { "fg": s:pink })
call s:h("Delimiter",     { "fg": s:pink })
call s:h("SpecialComment",{ "fg": s:aqua })
call s:h("Tag",           { "fg": s:pink })
"        Debug"

call s:h("Todo",          { "fg": s:orange,                       "format": "bold" })
call s:h("Comment",       { "fg": s:warmgrey })

call s:h("Underlined",    { "fg": s:green })
call s:h("Ignore",        {})
call s:h("Error",         { "fg": s:purered,  "bg": s:lightblack3 })

set background=dark

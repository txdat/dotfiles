" File:       monokai.vim
" Maintainer: Crusoe Xia (crusoexia)
" URL:        https://github.com/crusoexia/vim-monokai
" License:    MIT
"
" The colour palette is from http://www.colourlovers.com/

" Initialization
" --------------

set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "monokai"

function! s:h(group, style)
  let s:ctermformat = "NONE"
  let s:guiformat = "NONE"
  if has_key(a:style, "format")
    let s:ctermformat = a:style.format
    let s:guiformat = a:style.format
  endif
  let l:ctermfg = (has_key(a:style, "fg") ? a:style.fg.cterm : "NONE")
  let l:ctermbg = (has_key(a:style, "bg") ? a:style.bg.cterm : "NONE")
  execute "highlight" a:group
    \ "guifg="   (has_key(a:style, "fg")      ? a:style.fg.gui   : "NONE")
    \ "guibg="   (has_key(a:style, "bg")      ? a:style.bg.gui   : "NONE")
    \ "guisp="   (has_key(a:style, "sp")      ? a:style.sp.gui   : "NONE")
    \ "gui="     (!empty(s:guiformat) ? s:guiformat   : "NONE")
    \ "ctermfg=" . l:ctermfg
    \ "ctermbg=" . l:ctermbg
    \ "cterm="   (!empty(s:ctermformat) ? s:ctermformat   : "NONE")
endfunction

" Palettes
" --------

let s:black0 = { "gui": "#000000", "cterm": "NONE" }
let s:white0 = { "gui": "#bdbdbd", "cterm": "NONE" }

let s:white       = { "gui": "#E8E8E3", "cterm": "252" }
let s:white2      = { "gui": "#d8d8d3", "cterm": "250" }
let s:black       = { "gui": "#272822", "cterm": "234" }
let s:lightblack  = { "gui": "#2D2E27", "cterm": "235" }
let s:lightblack2 = { "gui": "#383a3e", "cterm": "236" }
let s:lightblack3 = { "gui": "#3f4145", "cterm": "237" }
let s:darkblack   = { "gui": "#211F1C", "cterm": "233" }
let s:br_grey     = { "gui": "#a1a29c", "cterm": "243" }
let s:grey        = { "gui": "#8F908A", "cterm": "243" }
let s:lightgrey   = { "gui": "#575b61", "cterm": "237" }
let s:darkgrey    = { "gui": "#64645e", "cterm": "239" }
let s:warmgrey    = { "gui": "#75715E", "cterm": "59"  }

let s:pink        = { "gui": "#F92772", "cterm": "197" }
let s:green       = { "gui": "#A6E22D", "cterm": "148" }
let s:aqua        = { "gui": "#66d9ef", "cterm": "81"  }
let s:yellow      = { "gui": "#E6DB74", "cterm": "186" }
let s:orange      = { "gui": "#FD9720", "cterm": "208" }
let s:purple      = { "gui": "#ae81ff", "cterm": "141" }
let s:red         = { "gui": "#e73c50", "cterm": "196" }
let s:purered     = { "gui": "#ff0000", "cterm": "52"  }
let s:darkred     = { "gui": "#5f0000", "cterm": "52"  }

let s:addfg       = { "gui": "#d7ffaf", "cterm": "193" }
let s:addbg       = { "gui": "#5f875f", "cterm": "65"  }
let s:delfg       = { "gui": "#ff8b8b", "cterm": "210" }
let s:delbg       = { "gui": "#f75f5f", "cterm": "124" }
let s:changefg    = { "gui": "#d7d7ff", "cterm": "189" }
let s:changebg    = { "gui": "#5f5f87", "cterm": "60"  }

let s:cyan        = { "gui": "#A1EFE4", "cterm": "159" }
let s:br_green    = { "gui": "#9EC400", "cterm": "148" }
let s:br_yellow   = { "gui": "#E7C547", "cterm": "221" }
let s:br_blue     = { "gui": "#7AA6DA", "cterm": "110" }
let s:br_purple   = { "gui": "#B77EE0", "cterm": "140" }
let s:br_cyan     = { "gui": "#54CED6", "cterm": "80"  }
let s:br_white    = { "gui": "#FFFFFF", "cterm": "16"  }

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
call s:h("SignColumn",    { })

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
call s:h("FoldColumn",    { })
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

" coc
" ---

call s:h("CocErrorSign",            { "fg": s:red })
call s:h("CocErrorHighlight",       { "fg": s:red })
call s:h("CocErrorFloat",           { "fg": s:purered,  "bg": s:lightblack3 })

call s:h("CocWarningSign",          { "fg": s:orange })
call s:h("CocWarningHighlight",     { "fg": s:orange })
call s:h("CocWarningFloat",         { "fg": s:orange,   "bg": s:lightblack3 })

call s:h("CocInfoSign",             { "fg": s:orange })
call s:h("CocInfoHighlight",        { "fg": s:orange })
call s:h("CocInfoFloat",            { "fg": s:aqua,     "bg": s:lightblack3 })

call s:h("CocHintSign",             { "fg": s:orange })
call s:h("CocHintHighlight",        { "fg": s:orange })
call s:h("CocHintFloat",            { "fg": s:aqua,     "bg": s:lightblack3 })

" Terminal Colors
" ---------------
if has('nvim')
  let g:terminal_color_0  = s:black.gui
  let g:terminal_color_1  = s:red.gui
  let g:terminal_color_2  = s:green.gui
  let g:terminal_color_3  = s:yellow.gui
  let g:terminal_color_4  = s:aqua.gui
  let g:terminal_color_5  = s:purple.gui
  let g:terminal_color_6  = s:cyan.gui
  let g:terminal_color_7  = s:white.gui
  let g:terminal_color_8  = s:darkgrey.gui
  let g:terminal_color_9  = s:pink.gui
  let g:terminal_color_10 = s:br_green.gui
  let g:terminal_color_11 = s:br_yellow.gui
  let g:terminal_color_12 = s:br_blue.gui
  let g:terminal_color_13 = s:br_purple.gui
  let g:terminal_color_14 = s:br_cyan.gui
  let g:terminal_color_15 = s:br_white.gui
else
  let g:terminal_ansi_colors = [
        \ s:black.gui,
        \ s:red.gui,
        \ s:green.gui,
        \ s:yellow.gui,
        \ s:aqua.gui,
        \ s:purple.gui,
        \ s:cyan.gui,
        \ s:white.gui,
        \ s:darkgrey.gui,
        \ s:pink.gui,
        \ s:br_green.gui,
        \ s:br_yellow.gui,
        \ s:br_blue.gui,
        \ s:br_purple.gui,
        \ s:br_cyan.gui,
        \ s:br_white.gui]
endif

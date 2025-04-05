" modus-themes.nvim
" url: https://github.com/miikanissi/modus-themes.nvim

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "modus"

function! s:h(group, style)
  if has_key(a:style, "link")
    execute "hi! link" a:group a:style.link
    return
  endif

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

" Base values
let s:bg_main = { "gui": "#000000" }
let s:bg_dim = { "gui": "#1e1e1e" }
let s:bg_alt = { "gui": "#0f0f0f" }
let s:fg_main = { "gui": "#bdbdbd" }
let s:fg_dim = { "gui": "#989898" }
let s:fg_alt = { "gui": "#c6daff" }
let s:border = { "gui": "#646464" }
let s:border_highlight = { "gui": "#c4c4c4" }

" Common foreground values
let s:red = { "gui": "#ff5f59" }
let s:red_warmer = { "gui": "#ff6b55" }
let s:red_cooler = { "gui": "#ff7f9f" }
let s:red_faint = { "gui": "#ff9580" }
let s:green = { "gui": "#44bc44" }
let s:green_warmer = { "gui": "#70b900" }
let s:green_cooler = { "gui": "#00c06f" }
let s:green_faint = { "gui": "#88ca9f" }
let s:yellow = { "gui": "#d0bc00" }
let s:yellow_warmer = { "gui": "#fec43f" }
let s:yellow_cooler = { "gui": "#dfaf7a" }
let s:yellow_faint = { "gui": "#d2b580" }
let s:blue = { "gui": "#2fafff" }
let s:blue_warmer = { "gui": "#79a8ff" }
let s:blue_cooler = { "gui": "#00bcff" }
let s:blue_faint = { "gui": "#82b0ec" }
let s:magenta = { "gui": "#feacd0" }
let s:magenta_warmer = { "gui": "#f78fe7" }
let s:magenta_cooler = { "gui": "#b6a0ff" }
let s:magenta_faint = { "gui": "#caa6df" }
let s:cyan = { "gui": "#00d3d0" }
let s:cyan_warmer = { "gui": "#4ae2f0" }
let s:cyan_cooler = { "gui": "#6ae4b9" }
let s:cyan_faint = { "gui": "#9ac8e0" }
let s:rust = { "gui": "#db7b5f" }
let s:gold = { "gui": "#c0965b" }
let s:olive = { "gui": "#9cbd6f" }
let s:slate = { "gui": "#76afbf" }
let s:indigo = { "gui": "#9099d9" }
let s:maroon = { "gui": "#cf7fa7" }
let s:pink = { "gui": "#d09dc0" }

" These foreground values can only be used for non-text elements with a 3:1
" contrast ratio. Combine with bg_main, bg_dim, bg_alt
let s:red_intense = { "gui": "#ff5f5f" }
let s:green_intense = { "gui": "#44df44" }
let s:yellow_intense = { "gui": "#efef00" }
let s:blue_intense = { "gui": "#338fff" }
let s:magenta_intense = { "gui": "#ff66ff" }
let s:cyan_intense = { "gui": "#00eff0" }

" Intense should only be combined with fg_main for text
let s:bg_red_intense = { "gui": "#9d1f1f" }
let s:bg_green_intense = { "gui": "#2f822f" }
let s:bg_yellow_intense = { "gui": "#7a6100" }
let s:bg_blue_intense = { "gui": "#1640b0" }
let s:bg_magenta_intense = { "gui": "#7030af" }
let s:bg_cyan_intense = { "gui": "#2266ae" }

" Subtle should be combined with fg_alt, fg_main
let s:bg_red_subtle = { "gui": "#620f2a" }
let s:bg_green_subtle = { "gui": "#00422a" }
let s:bg_yellow_subtle = { "gui": "#4a4000" }
let s:bg_blue_subtle = { "gui": "#242679" }
let s:bg_magenta_subtle = { "gui": "#552f5f" }
let s:bg_cyan_subtle = { "gui": "#004065" }

" Nuanced can be combined with corresponding foreground ie. bg_red_nuanced with red
let s:bg_red_nuanced = { "gui": "#2c0614" }
let s:bg_green_nuanced = { "gui": "#001904" }
let s:bg_yellow_nuanced = { "gui": "#221000" }
let s:bg_blue_nuanced = { "gui": "#0f0e39" }
let s:bg_magenta_nuanced = { "gui": "#230631" }
let s:bg_cyan_nuanced = { "gui": "#041529" }

" Special purpose
let s:bg_completion = { "gui": "#2f447f" }
let s:bg_hl_line = { "gui": "#2f3849" }
let s:bg_paren_match = { "gui": "#2f7f9f" }
let s:bg_paren_expression = { "gui": "#453040" }
let s:bg_char_0 = { "gui": "#0050af" }
let s:bg_char_1 = { "gui": "#7f1f7f" }
let s:bg_char_2 = { "gui": "#625a00" }

" Common active/inactive colors
let s:bg_active = { "gui": "#303030" }
let s:fg_active = { "gui": "#f4f4f4" }
let s:bg_inactive = { "gui": "#282828" }
let s:fg_inactive = { "gui": "#bfc0c4" }

" Status line specific colors
let s:bg_status_line_active = { "gui": "#404040" }
let s:fg_status_line_active = { "gui": "#f0f0f0" }
let s:bg_status_line_inactive = { "gui": "#2d2d2d" }
let s:fg_status_line_inactive = { "gui": "#969696" }

" tab bar colors for tab pages
let s:bg_tab_bar = { "gui": "#313131" }
let s:bg_tab_current = { "gui": "#000000" }
let s:bg_tab_other = { "gui": "#545454" }
let s:fg_tab_other = { "gui": "#f7f7f7" }
let s:bg_tab_alternate = { "gui": "#545490" }

" git diffs
let s:bg_added = { "gui": "#00381f" }
let s:bg_added_faint = { "gui": "#002910" }
let s:bg_added_refine = { "gui": "#034f2f" }
let s:bg_added_fringe = { "gui": "#237f3f" }
let s:fg_added = { "gui": "#a0e0a0" }
let s:fg_added_intense = { "gui": "#80e080" }
let s:bg_changed = { "gui": "#363300" }
let s:bg_changed_faint = { "gui": "#2a1f00" }
let s:bg_changed_refine = { "gui": "#4a4a00" }
let s:bg_changed_fringe = { "gui": "#8a7a00" }
let s:fg_changed = { "gui": "#efef80" }
let s:fg_changed_intense = { "gui": "#c0b05f" }
let s:bg_removed = { "gui": "#4f1119" }
let s:bg_removed_faint = { "gui": "#380a0f" }
let s:bg_removed_refine = { "gui": "#781a1f" }
let s:bg_removed_fringe = { "gui": "#b81a1f" }
let s:fg_removed = { "gui": "#ffbfbf" }
let s:fg_removed_intense = { "gui": "#ff9095" }
let s:bg_diff_context = { "gui": "#1a1a1a" }

let s:bg_sidebar = s:bg_dim
let s:fg_sidebar = s:fg_main
let s:cursor = s:fg_main
let s:comment = s:fg_dim
let s:error = s:red_cooler
let s:warning = s:yellow_cooler
let s:info = s:blue_cooler
let s:hint = s:cyan_cooler
let s:success = s:fg_added
let s:visual = s:bg_magenta_intense
let s:accent_light = s:blue_faint
let s:accent = s:blue_warmer
let s:accent_darker = s:blue
let s:accent_dark = s:blue_intense

" Highlighting
" ------------

" UI
call s:h("Normal", { "fg": s:fg_main, "bg": s:bg_main }) " Normal text.
" call s:h("NormalNC", { "fg": s:fg_inactive, "bg": s:bg_inactive }) " Normal text in non-current windows.
call s:h("NormalNC", { "fg": s:fg_main, "bg": s:bg_main }) " Normal text in non-current windows.
call s:h("NormalSB", { "fg": s:fg_sidebar, "bg": s:bg_sidebar }) " Normal text in sidebar.
call s:h("NormalFloat", { "fg": s:fg_active, "bg": s:bg_active }) " Float Window.
call s:h("FloatBorder", { "fg": s:border_highlight, "bg": s:bg_main }) " Float Border.
call s:h("FloatTitle", { "fg": s:border_highlight, "bg": s:bg_main }) " Float Title.
call s:h("Folded", { "fg": s:green_faint, "bg": s:bg_dim }) " Line for closed folds.
call s:h("LineNr", { "fg": s:fg_main, "bg": s:bg_dim }) " Line number for `:number` and `:#` commands, and when `number`, or `relativenumber` is set for the cursor line.
call s:h("LineNrAbove", { "fg": s:fg_dim, "bg": s:bg_dim }) " Line number above the cursor line.
call s:h("LineNrBelow", { "fg": s:fg_dim, "bg": s:bg_dim }) " Line number below the cursor line.
call s:h("CursorLineNr", { "fg": s:fg_active, "bg": s:bg_active, "format": "bold" }) " Like LineNr when `cursorline` or `relativenumber` is set for the cursor line.
call s:h("SignColumn", { "fg": s:fg_dim, "bg": s:bg_main }) " Column where |signs| are displayed.
call s:h("SignColumnSB", { "fg": s:fg_dim, "bg": s:bg_sidebar }) " Column where |signs| are displayed in the sidebar.
call s:h("CursorLine", { "bg": s:bg_hl_line }) " Screen-line at the cursor, when `cursorline` is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
call s:h("CursorColumn", { "bg": s:bg_hl_line }) " Screen-column at the cursor, when `cursorcolumn` is set.
call s:h("NonText", { "fg": s:fg_dim }) " `@` at the end of the window, characters from `showbreak` and other characters that do not really exist in the text (e.g., `>` displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
call s:h("ErrorMsg", { "fg": s:fg_main, "bg": s:bg_red_intense }) " Error messages on the command line.
call s:h("Conceal", { "fg": s:yellow_faint }) " Placeholder characters substituted for concealed text (see `conceallevel`).
call s:h("Cursor", { "fg": s:bg_main, "bg": s:cursor }) " Character under the cursor.
call s:h("lCursor", { "link": "Cursor" }) " Character under the cursor when |language-mapping| is used (see `guicursor`).
call s:h("CursorIM", { "link": "Cursor" }) " Like Cursor, but used when in IME mode |CursorIM|.
call s:h("ColorColumn", { "fg": s:fg_main, "bg": s:bg_dim }) " Used for the columns set with `colorcolumn`.
call s:h("FoldColumn", { "fg": s:fg_inactive, "bg": s:bg_inactive }) " See `foldcolumn`.
call s:h("Search", { "fg": s:fg_main, "bg": s:bg_green_intense }) " Last search pattern highlighting (see `hlsearch`).  Also used for similar items that need to stand out.
call s:h("IncSearch", { "fg": s:fg_main, "bg": s:bg_yellow_intense }) " `incsearch` highlighting; also used for the text replaced with `:s///c`.
call s:h("CurSearch", { "link": "IncSearch" })
call s:h("Substitute", { "fg": s:fg_main, "bg": s:bg_red_intense }) " |:substitute| replacement text highlighting.
call s:h("QuickFixLine", { "fg": s:fg_main, "bg": s:visual }) " Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
call s:h("Pmenu", { "fg": s:fg_active, "bg": s:bg_active }) " Popup menu: normal item.
call s:h("PmenuSel", { "fg": s:bg_active, "bg": s:fg_active }) " Popup menu: selected item.
call s:h("PmenuSbar", { "fg": s:fg_active, "bg": s:bg_dim }) " Popup menu: scrollbar.
call s:h("PmenuThumb", { "link": "Cursor" }) " Popup menu: Thumb of the scrollbar.
call s:h("Menu", { "link": "Pmenu" }) " Menu.
call s:h("Scrollbar", { "link": "PmenuSbar" }) " Scrollbar.
call s:h("Directory", { "fg": s:blue }) " Directory names (and other special names in listings).
call s:h("Title", { "fg": s:fg_alt, "format": "bold" }) " titles for output from `:set all`, `:autocmd` etc.
call s:h("Visual", { "fg": s:fg_main, "bg": s:visual }) " Visual mode selection.
call s:h("VisualNOS", { "link": "Visual" }) " Visual mode selection when vim is 'Not Owning the Selection'.
call s:h("WildMenu", { "fg": s:fg_main, "bg": s:visual }) " current match in `wildmenu` completion.
call s:h("Whitespace", { "link": "NonText" }) " `nbsp`, `space`, `tab` and `trail` in `listchars`.
call s:h("StatusLine", { "fg": s:fg_status_line_active, "bg": s:bg_status_line_active }) " Status line of current window.
call s:h("StatusLineNC", { "fg": s:fg_status_line_inactive, "bg": s:bg_status_line_inactive }) " Status lines of not-current windows Note: if this is equal to 'StatusLine' Vim will use `^^^` in the status line of the current window.
call s:h("TabLine", { "fg": s:fg_tab_other, "bg": s:bg_tab_other }) " Tab pages line, not active tab page label.
call s:h("TabLineSel", { "fg": s:fg_main, "bg": s:bg_tab_current, "format": "bold" }) " Tab pages line, active tab page label.
call s:h("TabLineFill", { "fg": s:fg_dim, "bg": s:bg_tab_bar }) " Tab pages line, where there are no labels.
call s:h("WinBar", { "link": "TabLineSel" }) " Window bar.
call s:h("WinBarNC", { "link": "TabLine" }) " Window bar in inactive windows.
call s:h("EndOfBuffer", { "fg": s:fg_inactive }) " Filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
call s:h("MatchParen", { "fg": s:fg_main, "bg": s:bg_paren_match }) " The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
call s:h("ModeMsg", { "fg": s:fg_dim, "format": "bold" }) " `showmode` message (e.g., `" INSERT " `).
call s:h("MsgArea", { "fg": s:fg_main }) " Area for messages and cmdline.
call s:h("MoreMsg", { "fg": s:blue }) " The |more-prompt|.
call s:h("VertSplit", { "fg": s:border }) " The column separating vertically split windows.
call s:h("WinSeparator", { "fg": s:border, "format": "bold" }) " The column separating vertically split windows.
call s:h("DiffAdd", { "fg": s:fg_added, "bg": s:bg_added }) " Diff mode: Added line |diff.txt|.
call s:h("DiffDelete", { "fg": s:fg_removed, "bg": s:bg_removed }) " Diff mode: Deleted line |diff.txt|.
call s:h("DiffChange", { "fg": s:fg_changed, "bg": s:bg_changed }) " Diff mode: Changed line |diff.txt|.
call s:h("DiffText", { "fg": s:fg_changed, "bg": s:bg_changed }) " Diff mode: Changed text within a changed line |diff.txt|.
call s:h("SpecialKey", { "fg": s:fg_dim }) " Unprintable characters: text displayed differently from what it really is.  But not `listchars` whitespace. |hl-Whitespace|.
call s:h("SpellBad", { "fg": s:error, "format": "undercurl" }) " Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
call s:h("SpellCap", { "fg": s:warning, "format": "undercurl" }) " Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
call s:h("SpellLocal", { "fg": s:info, "format": "undercurl" }) " Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
call s:h("SpellRare", { "fg": s:hint, "format": "undercurl" }) " Word that is recognized by the spellchecker as one that is hardly ever used. |spell| Combined with the highlighting used otherwise.
call s:h("WarningMsg", { "fg": s:warning }) " Warning messages.
call s:h("Question", { "fg": s:blue }) " |hit-enter| prompt and yes/no questions.

" Syntax
call s:h("Comment", { "fg": s:comment }) " Any comment.
call s:h("String", { "fg": s:blue_warmer }) " String constant (e.g. `'this is a string'`).
call s:h("Character", { "fg": s:blue_warmer }) " Character constant (e.g. `c`, `\n`).
call s:h("Boolean", { "fg": s:blue, "format": "bold" }) " Boolean constant (e.g. `TRUE`, `false`).
call s:h("Statement", { "fg": s:magenta_cooler }) " (preferred) any statement.
call s:h("Conditional", { "fg": s:magenta_cooler }) " `if`, `then`, `else`, `endif`, `switch`, etc.
call s:h("Repeat", { "fg": s:magenta_cooler }) " `for`, `do`, `while`, etc.
call s:h("Label", { "fg": s:cyan }) " `case`, `default`, etc.
call s:h("Keyword", { "fg": s:magenta_cooler }) " Any other keyword.
call s:h("Exception", { "fg": s:magenta_cooler }) " `try`, `catch`, `throw`, etc.
call s:h("StorageClass", { "fg": s:magenta_cooler }) " `static`, `register`, `volatile`, etc.
call s:h("Structure", { "fg": s:magenta_cooler }) " `struct`, `union`, `enum`, etc.
call s:h("Constant", { "fg": s:fg_main }) " (preferred) any constant.
call s:h("Function", { "fg": s:magenta }) " Function names.
call s:h("Identifier", { "fg": s:cyan }) " (preferred) any variable name.
call s:h("PreProc", { "fg": s:red_cooler }) " (preferred) generic preprocessor.
call s:h("Include", { "fg": s:red_cooler }) " preprocessor `#include`.
call s:h("Define", { "fg": s:red_cooler }) " preprocessor `#define`.
call s:h("Macro", { "fg": s:red_cooler }) " Same as Define.
call s:h("PreCondit", { "fg": s:red_cooler }) " preprocessor `#if`, `#else`, `#endif`, etc.
call s:h("Todo", { "fg": s:magenta, "format": "bold" }) " (preferred) anything that needs extra attention (e.g. `TODO`, `FIXME`, and `XXX`).
call s:h("Type", { "fg": s:cyan_cooler }) " (preferred) `int`, `long`, `char`, etc.
call s:h("TypeDef", { "fg": s:cyan_warmer }) " A typedef.
call s:h("Number", { "fg": s:blue_faint }) " Number constant (e.g. `234`, `0xff`).
call s:h("Float", { "link": "Number" }) " Floating point constant (e.g. `2.3e10`).
call s:h("Operator", { "fg": s:fg_main }) " `sizeof`, `+`, `*`, etc.
call s:h("Tag", { "fg": s:magenta }) " You can use CTRL-] on this.
call s:h("Delimiter", { "fg": s:fg_main }) " Character that needs attention (e.g. `.`).
call s:h("Special", { "link": "Type" })
call s:h("SpecialChar", { "fg": s:cyan_faint })
call s:h("Underlined", { "fg": s:fg_alt, "format": "underline" }) " (preferred) text that stands out (e.g. URIs).
call s:h("Error", { "fg": s:fg_main, "bg": s:bg_red_intense }) " (preferred) any erroneous construct.

" Miscelaneous Syntax related non-standard highlights.
call s:h("qfLineNr", { "fg": s:fg_dim })
call s:h("qfFileName", { "fg": s:blue })

call s:h("htmlH1", { "fg": s:blue, "format": "bold" })
call s:h("htmlH2", { "fg": s:yellow, "format": "bold" })
call s:h("htmlH3", { "fg": s:magenta, "format": "bold" })
call s:h("htmlH4", { "fg": s:green, "format": "bold" })
call s:h("htmlH5", { "fg": s:red, "format": "bold" })
call s:h("htmlH6", { "fg": s:cyan_warmer, "format": "bold" })

call s:h("mkdCodeDelimiter", { "bg": s:bg_alt, "fg": s:fg_main })
call s:h("mkdCodeStart", { "fg": s:cyan_cooler, "format": "bold" })
call s:h("mkdCodeEnd", { "fg": s:cyan_cooler, "format": "bold" })

call s:h("markdownHeadingDelimiter", { "fg": s:rust, "format": "bold" })
call s:h("markdownCode", { "fg": s:cyan_cooler })
call s:h("markdownCodeBlock", { "fg": s:cyan_cooler })
call s:h("markdownLinkText", { "fg": s:blue, "format": "underline" })
call s:h("markdownH1", { "fg": s:blue, "format": "bold" })
call s:h("markdownH2", { "fg": s:yellow, "format": "bold" })
call s:h("markdownH3", { "fg": s:magenta, "format": "bold" })
call s:h("markdownH4", { "fg": s:green, "format": "bold" })
call s:h("markdownH5", { "fg": s:red, "format": "bold" })
call s:h("markdownH6", { "fg": s:cyan_warmer, "format": "bold" })

" These groups are for the native LSP client. Some other LSP clients may
" use these groups, or use their own. Consult your LSP client's
" documentation.
call s:h("LspCodeLens", { "fg": s:comment })
call s:h("LspInlayHint", { "bg": s:bg_main, "fg": s:comment, "format": "italic" })
call s:h("LspReferenceText", { "bg": s:bg_blue_intense, "fg": s:fg_main }) " used for highlighting 'text' references.
call s:h("LspReferenceRead", { "bg": s:bg_blue_intense, "fg": s:fg_main }) " used for highlighting 'read' references.
call s:h("LspReferenceWrite", { "bg": s:bg_blue_intense, "fg": s:fg_main }) " used for highlighting 'write' references.
call s:h("LspSignatureActiveParameter", { "link": "Visual" })
call s:h("LspInfoBorder", { "fg": s:border_highlight, "bg": s:bg_main })

" These are used by the native diagnostics.
call s:h("DiagnosticError", { "fg": s:error, "format": "bold" }) " Used as the base highlight group. Other Diagnostic highlights link to this by default.
call s:h("DiagnosticWarn", { "fg": s:warning, "format": "bold" }) " Used as the base highlight group. Other Diagnostic highlights link to this by default.
call s:h("DiagnosticInfo", { "fg": s:info, "format": "bold" }) " Used as the base highlight group. Other Diagnostic highlights link to this by default.
call s:h("DiagnosticHint", { "fg": s:hint, "format": "bold" }) " Used as the base highlight group. Other Diagnostic highlights link to this by default.
call s:h("DiagnosticUnnecessary", { "fg": s:fg_dim }) " Used as the base highlight group. Other Diagnostic highlights link to this by default.

call s:h("DiagnosticVirtualTextError", { "fg": s:error, "format": "bold" }) " Used for 'Error' diagnostic virtual text.
call s:h("DiagnosticVirtualTextWarn", { "fg": s:warning, "format": "bold" }) " Used for 'Warning' diagnostic virtual text.
call s:h("DiagnosticVirtualTextInfo", { "fg": s:info, "format": "bold" }) " Used for 'Information' diagnostic virtual text.
call s:h("DiagnosticVirtualTextHint", { "fg": s:hint, "format": "bold" }) " Used for 'Hint' diagnostic virtual text.

call s:h("DiagnosticUnderlineError", { "format": "undercurl", "fg": s:error }) " Used to underline 'Error' diagnostics.
call s:h("DiagnosticUnderlineWarn", { "format": "undercurl", "fg": s:warning }) " Used to underline 'Warning' diagnostics.
call s:h("DiagnosticUnderlineInfo", { "format": "undercurl", "fg": s:info }) " Used to underline 'Information' diagnostics.
call s:h("DiagnosticUnderlineHint", { "format": "undercurl", "fg": s:hint }) " Used to underline 'Hint' diagnostics.

" Neovim tree-sitter highlights
if has("nvim")
  " Identifiers
  call s:h("@variable", { "link": "Identifier" }) " Any variable name that does not have another highlight.
  call s:h("@variable.builtin", { "link": "Conditional" }) " Variable names that are defined by the languages, like `this` or `self`.
  call s:h("@variable.parameter", { "fg": s:cyan }) " Parameters of a function.
  call s:h("@variable.parameter.builtin", { "fg": s:cyan_faint }) " Built-in parameters of a function (e.g. `...` or `_`).
  call s:h("@variable.member", { "link": "Identifier" }) " Object and struct fields.

  call s:h("@constant", { "link": "Constant" }) " Constant identifier.
  call s:h("@constant.builtin", { "link": "Special" }) " Built-in constant values.
  call s:h("@constant.macro", { "link": "Define" }) " Constants defined by the preprocessor.

  call s:h("@module", { "link": "Include" }) " Modules or namespaces.
  call s:h("@module.builtin", { "link": "Conditional" }) " Built-in modules or namespaces.
  call s:h("@label", { "link": "Label" }) " GOTO and other labels (e.g. `label:` in C and `:label:` in Lua).

  " Literals
  call s:h("@string", { "link": "String" }) " String literals.
  call s:h("@string.documentation", { "fg": s:green_faint }) " String documening code (e.g. Python docstrings).
  call s:h("@string.regex", { "fg": s:green_cooler }) " Regular expressions.
  call s:h("@string.escape", { "fg": s:yellow_faint }) " Escape characters within a string.
  call s:h("@string.special", { "fg": s:red_faint }) " Other special strings (e.g. dates).
  call s:h("@string.special.symbol", { "link": "Identifier" }) " Symbols or atoms.
  call s:h("@string.special.path", { "fg": s:blue }) " Filenames.
  call s:h("@string.special.url", { "fg": s:cyan_cooler }) " URIs (e.g. hyperlinks).

  call s:h("@character", { "link": "Character" }) " Character literals.
  call s:h("@character.special", { "link": "SpecialChar" }) " Special characters (e.g. wildcards).

  call s:h("@boolean", { "link": "Boolean" }) " Boolean literals.
  call s:h("@number", { "link": "Number" }) " Numeric literals.
  call s:h("@number.float", { "link": "Float" }) " Floating-point number literals.

  " Types
  call s:h("@type", { "link": "Type" }) " Type or class definitions and annotations.
  call s:h("@type.builtin", { "link": "Type" }) " Built-in types.
  call s:h("@type.definition", { "link": "Typedef" }) " Identifiers in type definitions (e.g. `typedef <type> <identifier>` in C).

  call s:h("@attribute", { "link": "PreProc" }) " Attribute annotations (e.g. Python decorators).
  call s:h("@attribute.builtin", { "link": "PreProc" }) " Built-in annotations (e.g. `property` in Python).
  call s:h("@property", { "link": "@field" }) " The key in key-value pairs.

  " Functions
  call s:h("@function", { "link": "Function" }) " Function definitions.
  call s:h("@function.builtin", { "link": "Special" }) " Built-in functions.
  call s:h("@function.call", { "link": "@function" }) " Function calls.
  call s:h("@function.macro", { "link": "Macro" }) " Preprocessor calls.

  call s:h("@function.method", { "link": "Function" }) " Method definitions.
  call s:h("@function.method.call", { "link": "@function.method" }) " Method calls.

  call s:h("@constructor", { "fg": s:yellow_cooler }) " Constructor calls and definitions (e.g. `= { }` in Lua, and Java constructors).
  call s:h("@operator", { "link": "Operator" }) " Symbolic operators (e.g. `+`, but also `->` and `*` in C).

  " Keywords
  call s:h("@keyword", { "link": "Keyword" }) " Keywords that don't fall in specific categories.
  call s:h("@keyword.coroutine", { "link": "@keyword" }) " Keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
  call s:h("@keyword.function", { "link": "Function" }) " Keywords that define a function (e.g. `func` in Go, `def` in Python).
  call s:h("@keyword.operator", { "link": "@operator" }) " Operators that are words (e.g. `and`, `or`).
  call s:h("@keyword.import", { "link": "Include" }) " Keywords for including imports (e.g. `import`, `from` in Python).
  call s:h("@keyword.type", { "link": "@type" }) " Keywords defining composite types (e.g. `struct`, `enum` in C).
  call s:h("@keyword.modifier", { "link": "@keyword" }) " Keywords defining type modifiers (e.g. `const`, `static`, `public`).
  call s:h("@keyword.repeat", { "link": "Repeat" }) " Keywords related to loops (e.g. `for`, `while`).
  call s:h("@keyword.return", { "link": "@keyword" }) " Keywords like `return` and `yield`.
  call s:h("@keyword.debug", { "link": "Debug" }) " Keywords related to debugging (e.g. `assert`).
  call s:h("@keyword.exception", { "link": "Exception" }) " Keywords related to exceptions (e.g. `throw`, `catch`).

  call s:h("@keyword.conditional", { "link": "Conditional" }) " Conditionals (e.g. `if`, `else`).
  call s:h("@keyword.conditional.ternary", { "link": "Conditional" }) " Ternary operators (e.g. `?`, `:`).

  call s:h("@keyword.directive", { "link": "PreProc" }) " Preprocessor directives and shebangs.
  call s:h("@keyword.directive.define", { "link": "Define" }) " Preprocessor definition directives.

  " Punctuation
  call s:h("@punctuation.delimiter", { "link": "Delimiter" }) " Delimiters (e.g. `.`, `,` `:`).
  call s:h("@punctuation.bracket", { "fg": s:fg_main }) " Brackets and parens (e.g. `()`, `{ }`, `call s:h(]`).
  call s:h("@punctuation.special", { "fg": s:fg_main }) " Special symbols (e.g. `{ }` in string interpolation).

  " Comments
  call s:h("@comment", { "link": "Comment" }) " Line and block comments.
  call s:h("@comment.documentation", { "link": "@string.documentation" }) " Comments documenting code.

  call s:h("@comment.error", { "fg": s:error }) " Error-type comments (e.g. `ERROR`, `FIXME`, `DEPRECATED`).
  call s:h("@comment.warning", { "fg": s:warning }) " Warning-type comments (e.g. `WARNING`, `HACK`, `FIX`).
  call s:h("@comment.todo", { "link": "Todo" }) " Todo-type comments (e.g. `TODO`, `WIP`).
  call s:h("@comment.note", { "fg": s:hint }) " Note-type comments (e.g. `NOTE`, `INFO`, `XXX`).

  " Markup
  call s:h("@markup.strong", { "format": "bold" }) " Bold text.
  call s:h("@markup.italic", { "format": "italic" }) " Italic text.
  call s:h("@markup.strikethrough", { "format": "strikethrough" }) " Struck-through text.
  call s:h("@markup.underline", { "format": "underline" }) " Underlined text.

  call s:h("@markup.heading", { "link": "Title" }) " Headings and titles.
  call s:h("@markup.heading.1", { "fg": s:blue, "format": "bold" }) " Top-level heading.
  call s:h("@markup.heading.2", { "fg": s:yellow, "format": "bold" }) " Section heading.
  call s:h("@markup.heading.3", { "fg": s:magenta, "format": "bold" }) " Subsection heading.
  call s:h("@markup.heading.4", { "fg": s:green, "format": "bold" }) " And so on ...
  call s:h("@markup.heading.5", { "fg": s:red, "format": "bold" }) " And so forth ...
  call s:h("@markup.heading.6", { "fg": s:cyan_warmer, "format": "bold" }) " Last highlighted level.

  call s:h("@markup.quote", { "format": "italic" }) " Block quotes.
  call s:h("@markup.math", { "link": "Special" }) " Math environments (e.g. `$ ... $` in LaTeX).

  call s:h("@markup.link", { "fg": s:cyan_cooler }) " Text references, footnotes, citations.
  call s:h("@markup.link.label", { "link": "SpecialChar" }) " Link, reference descriptions.
  call s:h("@markup.link.label.symbol", { "link": "Identifier" }) " Symbols within a link description.
  call s:h("@markup.link.url", { "link": "Underlined" }) " URL-style links.

  call s:h("@markup.raw", { "link": "String" }) " Literal or verbatim text (e.g. inline code).
  call s:h("@markup.raw.block", { "link": "String" }) " Literal or verbatim text as standalone text.

  call s:h("@markup.list", { "fg": s:fg_main }) " List markers.
  call s:h("@markup.list.checked", { "fg": s:green }) " Checked todo list markers.
  call s:h("@markup.list.unchecked", { "fg": s:yellow }) " Unchecked todo list markers.

  call s:h("@diff.plus", { "link": "DiffAdd" }) " Added lines in a diff.
  call s:h("@diff.minus", { "link": "DiffDelete" }) " Removed lines in a diff.
  call s:h("@diff.delta", { "link": "DiffChange" }) " Changed lines in a diff.

  call s:h("@tag", { "link": "Label" }) " XML-style tag names (e.g. in XML, HTML).
  call s:h("@tag.attribute", { "link": "@property" }) " XML-style tag attributes.
  call s:h("@tag.delimiter", { "link": "Delimiter" }) " XML-style tag delimiters.

  call s:h("@none", { })

  " tsx
  call s:h("@tag.tsx", { "fg": s:red })
  call s:h("@constructor.tsx", { "fg": s:blue })
  call s:h("@tag.delimiter.tsx", { "fg": s:blue_cooler })

  " Python
  call s:h("@lsp.type.namespace.python", { "link": "@variable" })

  " LSP Semantic Token Groups
  call s:h("@lsp.type.boolean", { "link": "@boolean" })
  call s:h("@lsp.type.builtinType", { "link": "@type.builtin" })
  call s:h("@lsp.type.comment", { "link": "@comment" })
  call s:h("@lsp.type.decorator", { "link": "@attribute" })
  call s:h("@lsp.type.deriveHelper", { "link": "@attribute" })
  call s:h("@lsp.type.enum", { "link": "@type" })
  call s:h("@lsp.type.enumMember", { "link": "@constant" })
  call s:h("@lsp.type.escapeSequence", { "link": "@string.escape" })
  call s:h("@lsp.type.formatSpecifier", { "link": "@markup.list" })
  call s:h("@lsp.type.generic", { "link": "@variable" })
  call s:h("@lsp.type.interface", { "fg": s:blue_warmer })
  call s:h("@lsp.type.keyword", { "link": "@keyword" })
  call s:h("@lsp.type.lifetime", { "link": "@keyword.storage" })
  call s:h("@lsp.type.namespace", { "link": "@module" })
  call s:h("@lsp.type.number", { "link": "@number" })
  call s:h("@lsp.type.operator", { "link": "@operator" })
  call s:h("@lsp.type.parameter", { "link": "@variable.parameter" })
  call s:h("@lsp.type.property", { "link": "@property" })
  call s:h("@lsp.type.selfKeyword", { "link": "@variable.builtin" })
  call s:h("@lsp.type.selfTypeKeyword", { "link": "@variable.builtin" })
  call s:h("@lsp.type.string", { "link": "@string" })
  call s:h("@lsp.type.typeAlias", { "link": "@type.definition" })
  call s:h("@lsp.type.unresolvedReference", { "format": "undercurl", "fg": s:error })
  call s:h("@lsp.type.variable", { }) " use treesitter styles for regular variables
  call s:h("@lsp.typemod.class.defaultLibrary", { "link": "@type.builtin" })
  call s:h("@lsp.typemod.enum.defaultLibrary", { "link": "@type.builtin" })
  call s:h("@lsp.typemod.enumMember.defaultLibrary", { "link": "@constant.builtin" })
  call s:h("@lsp.typemod.function.defaultLibrary", { "link": "@function.builtin" })
  call s:h("@lsp.typemod.keyword.async", { "link": "@keyword.coroutine" })
  call s:h("@lsp.typemod.keyword.injected", { "link": "@keyword" })
  call s:h("@lsp.typemod.macro.defaultLibrary", { "link": "@function.builtin" })
  call s:h("@lsp.typemod.method.defaultLibrary", { "link": "@function.builtin" })
  call s:h("@lsp.typemod.operator.injected", { "link": "@operator" })
  call s:h("@lsp.typemod.string.injected", { "link": "@string" })
  call s:h("@lsp.typemod.struct.defaultLibrary", { "link": "@type.builtin" })
  call s:h("@lsp.typemod.type.defaultLibrary", { "fg": s:blue_cooler })
  call s:h("@lsp.typemod.typeAlias.defaultLibrary", { "fg": s:blue_cooler })
  call s:h("@lsp.typemod.variable.callable", { "link": "@function" })
  call s:h("@lsp.typemod.variable.defaultLibrary", { "link": "@variable.builtin" })
  call s:h("@lsp.typemod.variable.injected", { "link": "@variable" })
  call s:h("@lsp.typemod.variable.static", { "link": "@constant" })
endif

" Plugins
" -------

if has("nvim")
  " Lazy
  call s:h("LazyProgressDone", { "format": "bold", "fg": s:magenta_cooler })
  call s:h("LazyProgressTodo", { "format": "bold", "fg": s:fg_dim })

  " GitSigns
  call s:h("GitSignsAdd", { "fg": s:fg_added_intense, "bg": s:bg_added }) " diff mode: Added line |diff.txt|
  call s:h("GitSignsChange", { "fg": s:fg_changed_intense, "bg": s:bg_changed }) " diff mode: Changed line |diff.txt|
  call s:h("GitSignsDelete", { "fg": s:fg_removed_intense, "bg": s:bg_removed }) " diff mode: Deleted line |diff.txt|
endif

set background=dark

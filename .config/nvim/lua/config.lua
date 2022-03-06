-- nvim's global configurations

-----------------------------------------
-- neovim's aliases
-----------------------------------------

local cmd = vim.cmd  -- execute vim's commands
local exec = vim.api.nvim_exec  -- execute vimscript
local fn = vim.fn  -- vim's functions
local g = vim.g  -- global variables
local opt = vim.opt -- global/buffer/windows-scoped options

-----------------------------------------
-- startup
-----------------------------------------

-- disable builtins
local disabled_built_ins = {
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"gzip",
	"zip",
	"zipPlugin",
	"tar",
	"tarPlugin",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"logipat",
	"rrhelper",
	"spellfile_plugin",
	"matchit"
}

for _, plugin in pairs(disabled_built_ins) do
	g['loaded_'..plugin] = 1
end

-- nvim intro
-- TODO: customize :))
opt.shortmess:append 'sI'  -- disable

-----------------------------------------
-- general
-----------------------------------------

g.mapleader = ','
--opt.mouse = 'a'
opt.clipboard = 'unnamedplus' -- system's clipboard
--opt.swapfile = false
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

-----------------------------------------
-- neovim's ui
-----------------------------------------

opt.number = true
opt.showmatch = true  -- highlight matching parenthesis
opt.foldmethod = 'marker'  -- enable folding
--opt.colorcolumn = '80'  -- line marker at column:80
opt.splitright = true  -- vertical split to the right
opt.splitbelow = true  -- horizontal split to the bottom
opt.ignorecase = true  -- ignore case sensitive when searching
opt.smartcase = true  -- ignore lowercase for the whole pattern
opt.linebreak = true  -- wrap on word boundary

-- remove whitespace on saving
cmd [[au BufWritePre * :%s/\s\+$//e]]

-- highlight on yank (selected copy)
--exec ([[
--	augroup YankHighlight
--		autocmd!
--		autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
--	augroup end
--]], false)

-- cursor
opt.guicursor = 'i:block'  -- using block cursor

-----------------------------------------
-- tabs, indent
-----------------------------------------

opt.expandtab = true  -- use spaces instead of tab
opt.smarttab = true
opt.smartindent = true
opt.tabstop = 4  -- 1 tab = 4 spaces
opt.softtabstop = 0
opt.shiftwidth = 4  -- shifts 4 spaces when using tab

-- not auto commenting new lines
cmd [[au BufEnter * set fo-=c fo-=r fo-=o]]

-- remove line marker for selected filetypes
--cmd [[autocmd FileType text,markdown,html,xhtml,javascript setlocal cc=0]]

-- specified spaces for selected filetypes
--cmd [[autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml setlocal shiftwidth=2 tabstop=2]]

-----------------------------------------
-- cpu, memory
-----------------------------------------

opt.hidden = true  -- enable background buffers
opt.history = 100  -- n lines in history
opt.lazyredraw = true  -- faster scrolling
opt.synmaxcol = 240  -- max column for syntax highlight

-----------------------------------------
-- terminal
-----------------------------------------

-- open terminal pane on the right
cmd [[command Term :botright vsplit term://$SHELL]]

-- visual tweaks
cmd [[
	autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
	autocmd TermOpen * startinsert
	autocmd BufLeave term://* stopinsert
]]

-----------------------------------------
-- colorscheme
-----------------------------------------

opt.termguicolors = true  -- enable 24bits colors

-----------------------------------------
-- autocompletion
-----------------------------------------

opt.completeopt = 'menuone,noselect'  -- insert mode


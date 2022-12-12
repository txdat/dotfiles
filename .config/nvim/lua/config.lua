local g = vim.g  -- global variables
local opt = vim.opt  -- global/buffer/windows-scoped options
local cmd = vim.cmd  -- execute vim's commands
local augroup = vim.api.nvim_create_augroup  -- create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd  -- create autocommand

-- disable built-in plugins
local disabled_built_ins = {
   "2html_plugin",
   "getscript",
   "getscriptPlugin",
   "gzip",
   "logipat",
   "netrw",
   "netrwPlugin",
   "netrwSettings",
   "netrwFileHandlers",
   "matchit",
   "tar",
   "tarPlugin",
   "rrhelper",
   "spellfile_plugin",
   "vimball",
   "vimballPlugin",
   "zip",
   "zipPlugin",
   "tutor",
   "rplugin",
   "synmenu",
   "optwin",
   "compiler",
   "bugreport",
   "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
	g['loaded_' .. plugin] = 1
end

-----------------------------------------
-- general
-----------------------------------------

opt.clipboard = 'unnamed,unnamedplus' -- system's clipboard
opt.textwidth = 0
opt.timeoutlen = 100
opt.swapfile = false
opt.completeopt = 'menuone,noinsert,noselect'  -- insert mode
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

-----------------------------------------
-- gui
-----------------------------------------

opt.shortmess:append 'sI'  -- disable nvim intro
opt.termguicolors = true  -- enable 24bits colors
--opt.guicursor = 'i:block'  -- using block cursor
opt.guicursor = 'n-v-c:block-Cursor'
opt.guicursor:append 'i:block-iCursor'
opt.guicursor:append 'n-v-c:blinkon0'
opt.guicursor:append 'i:blinkon0'
--opt.ruler = true  -- show cursor position
opt.number = true  -- show line number
opt.showmatch = true  -- highlight matching parenthesis
opt.foldmethod = 'marker'  -- enable folding
opt.splitright = true  -- vertical split to the right
opt.splitbelow = true  -- horizontal split to the bottom
opt.linebreak = true  -- wrap on word boundary
opt.laststatus=3  -- set global statusline

-----------------------------------------
-- tabs, indent
-----------------------------------------

opt.autoindent = true
opt.cindent = true
opt.smartindent = true
opt.smarttab = true
opt.expandtab = true  -- use spaces instead of tab
opt.tabstop = 4  -- 1 tab = 4 spaces
opt.softtabstop = 0
opt.shiftwidth = 4  -- shifts 4 spaces when using tab
opt.shiftround = true

-----------------------------------------
-- searching
-----------------------------------------

opt.hlsearch = true  -- highlight search result
opt.incsearch = true  -- show first match when start typing
opt.ignorecase = true  -- ignore case sensitive when searching
opt.smartcase = true  -- ignore lowercase for the whole pattern

-----------------------------------------
-- cpu, memory
-----------------------------------------

opt.hidden = true  -- enable background buffers
opt.history = 100  -- n lines in history
opt.lazyredraw = true  -- faster scrolling
opt.synmaxcol = 240  -- max column for syntax highlight
opt.updatetime = 700  -- ms to wait for trigger an event

-----------------------------------------
-- autocommand functions
-----------------------------------------

-- highlight on yank (selected copy)
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
    group = 'YankHighlight',
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = '1000' })
    end
})

-- remove whitespace on save
autocmd('BufWritePre', {
    pattern = '*',
    command = ':%s/\\s\\+$//e'
})

-- don't auto commenting new lines
autocmd('BufEnter', {
    pattern = '*',
    command = 'set fo-=c fo-=r fo-=o'
})

-- terminal config ----------------------

-- open terminal on the right tab
autocmd('CmdlineEnter', {
    command = 'command! Term :botright vsplit term://$SHELL'
})

-- enter insert mode when switching to terminal
autocmd('TermOpen', {
    command = 'setlocal listchars= nonumber norelativenumber nocursorline'
})

autocmd('TermOpen', {
    pattern = '*',
    command = 'startinsert'
})

-- close terminal buffer on process exit
autocmd('BufLeave', {
    pattern = '*',
    command = 'stopinsert'
})

-- python interpreter
local handler = io.popen("which python3")
g.python3_host_prog = handler:read("*a"):gsub("\n[^\n]*$", "")
handler:close()

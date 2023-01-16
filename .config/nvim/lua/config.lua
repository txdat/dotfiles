-- vim/neovim config

local opt = vim.opt
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- disable built-in plugins
local built_in_plugins = {
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

for _, plugin in ipairs(built_in_plugins) do
    vim.g["loaded_" .. plugin] = 1
end

-----------------------------------------
-- general
-----------------------------------------

opt.clipboard = "unnamed,unnamedplus" -- system"s clipboard
opt.timeout = true
opt.timeoutlen = 500 -- key mappings timeout
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.completeopt = "menu,menuone,noinsert,noselect" -- insert mode
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.mouse = "a" -- enable mouse support
opt.errorbells = false
vim.g.mapleader = "\\"

-----------------------------------------
-- gui
-----------------------------------------

vim.g.colors_name = "kanagawa"
opt.background = "dark"
opt.shortmess:append "sI" -- disable nvim intro
opt.laststatus = 3 -- set global statusline
opt.termguicolors = true -- enable 24bits colors
opt.guicursor = "n-v-c:block-Cursor" -- using block cursor
opt.guicursor:append "i:block-iCursor"
opt.guicursor:append "n-v-c:blinkon0"
opt.guicursor:append "i:blinkon0"
--opt.ruler = true  -- show cursor position
opt.list = true -- show eol, ...
opt.cursorline = true
opt.number = true -- show line number
opt.relativenumber = true -- (-1,+1) line number
opt.showmatch = true -- highlight matching parenthesis
opt.foldmethod = "marker" -- enable folding
opt.splitright = true -- vertical split to the right
opt.splitbelow = true -- horizontal split to the bottom
opt.signcolumn = "yes"

-----------------------------------------
-- tabs, indent, ...
-----------------------------------------

opt.autoindent = true
opt.cindent = true
opt.smartindent = true
opt.smarttab = true
opt.expandtab = true -- use spaces instead of tab
opt.tabstop = 4 -- 1 tab = 4 spaces
opt.softtabstop = 0
opt.shiftwidth = 4 -- shifts 4 spaces when using tab
opt.shiftround = true
opt.linebreak = true -- wrap on word boundary
opt.textwidth = 0

-----------------------------------------
-- searching
-----------------------------------------

opt.hlsearch = true -- highlight search result
opt.incsearch = true -- show first match when start typing
opt.ignorecase = true -- ignore case sensitive when searching
opt.smartcase = true -- ignore lowercase for the whole pattern

-----------------------------------------
-- cpu, memory
-----------------------------------------

opt.hidden = true -- enable background buffers
opt.history = 100 -- n lines in history
opt.lazyredraw = true -- faster scrolling
opt.synmaxcol = 240 -- max column for syntax highlight
opt.updatetime = 250 -- milli-seconds to wait for trigger an event (keymap)

-----------------------------------------
-- providers
-----------------------------------------

-- python
vim.g.python3_host_prog = require("util").exec("which python3")

-----------------------------------------
-- autocommand functions
-----------------------------------------

-- highlight on yank (selected copy)
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    group = "YankHighlight",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = "1000" })
    end
})

-- remove whitespace on save
autocmd("BufWritePre", {
    pattern = "*",
    command = ":%s/\\s\\+$//e"
})

-- don"t auto commenting new lines
autocmd("BufEnter", {
    pattern = "*",
    command = "set fo-=c fo-=r fo-=o"
})

-- open terminal
autocmd("CmdlineEnter", {
    command = "command! Term :botright split term://$SHELL"
})

-- enter insert mode when switching to terminal
autocmd("TermOpen", {
    command = "setlocal listchars= nonumber norelativenumber nocursorline"
})

autocmd("TermOpen", {
    pattern = "*",
    command = "startinsert"
})

-- close terminal buffer on process exit
autocmd("BufLeave", {
    pattern = "*",
    command = "stopinsert"
})

-----------------------------------------
-- plugins
-----------------------------------------

pcall(require, "plugins")

-----------------------------------------
-- keymaps
-----------------------------------------

pcall(require, "keymaps")

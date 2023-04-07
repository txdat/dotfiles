-- neovim config

local opt = vim.opt

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
opt.timeoutlen = 500                  -- key mappings timeout
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.completeopt = "menu,menuone,noinsert,noselect" -- insert mode
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.mouse = "a" -- enable mouse support
opt.errorbells = false
-- vim.g.mapleader = " "
vim.g.mapleader = "\\"

-- spelling
vim.opt.spelllang = "en_us"
-- vim.opt.spell = true

-----------------------------------------
-- gui
-----------------------------------------

opt.background = "dark"
opt.shortmess:append "sI"            -- disable nvim intro
opt.laststatus = 3                   -- set global statusline
opt.termguicolors = true             -- enable 24bits colors
opt.guicursor = "n-v-c:block-Cursor" -- using block cursor
opt.guicursor:append "i:block-iCursor"
opt.guicursor:append "n-v-c:blinkon0"
opt.guicursor:append "i:blinkon0"
opt.colorcolumn = "80"
-- opt.ruler = true  -- show cursor position
opt.list = true           -- show eol, ...
opt.cursorline = true
opt.number = true         -- show line number
opt.relativenumber = true -- (-1,+1) line number
opt.showmatch = true      -- highlight matching parenthesis
opt.foldmethod = "marker" -- enable folding
opt.splitright = true     -- vertical split to the right
opt.splitbelow = true     -- horizontal split to the bottom
opt.signcolumn = "yes"
opt.fillchars = [[eob: ,fold: ,foldopen:-,foldsep:│,foldclose:+]]
opt.foldcolumn = "1"
opt.statuscolumn = "%=%s%=%l %C%#IndentBlankLineChar#│ "

-----------------------------------------
-- tabs, indent, ...
-----------------------------------------

opt.autoindent = true
opt.cindent = true
opt.smartindent = true
opt.smarttab = true
opt.expandtab = true -- use spaces instead of tab
opt.tabstop = 4      -- 1 tab = 4 spaces
opt.softtabstop = 0
opt.shiftwidth = 4   -- shifts 4 spaces when using tab
opt.shiftround = true
opt.linebreak = true -- wrap on word boundary
opt.textwidth = 0

-----------------------------------------
-- searching
-----------------------------------------

opt.hlsearch = true   -- highlight search result
opt.incsearch = true  -- show first match when start typing
opt.ignorecase = true -- ignore case sensitive when searching
opt.smartcase = true  -- ignore lowercase for the whole pattern

-----------------------------------------
-- cpu, memory
-----------------------------------------

opt.hidden = true     -- enable background buffers
opt.history = 100     -- n lines in history
opt.lazyredraw = true -- faster scrolling
opt.synmaxcol = 240   -- max column for syntax highlight
opt.updatetime = 250  -- milli-seconds to wait for trigger an event (keymap)

-----------------------------------------
-- providers
-----------------------------------------

-- python
vim.g.python3_host_prog = require("util").shell_cmd("which python3")

-----------------------------------------
-- autocommand functions
-----------------------------------------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- highlight on yank (selected copy)
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    group = "YankHighlight",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = "500" })
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

-- close terminal buffer on process exit
autocmd("BufLeave", {
    pattern = "*",
    command = "stopinsert"
})

-----------------------------------------
-- keymaps
-----------------------------------------

local keymap = require("util").keymap

-- remap recoding
keymap("n", "<leader>q", "q")
keymap("n", "q", "<nop>")

keymap("n", "<F1>", "<nop>")
keymap("n", "<F7>", ":setlocal spell! spell?<CR>")

keymap("n", "H", "^")
keymap("n", "L", "$")

-- keymap("n", "<C-t>", ":Term<CR>")  -- open terminal
-- keymap("t", "<Esc>", "<C-\\><C-n>") -- exit without closing

-- switch buffers
keymap("n", "<C-[>", ":bprevious<CR>")
keymap("n", "<C-]>", ":bnext<CR>")
keymap("n", "<C-\\>", ":b#<CR>") -- switch to last buffer

-- close current buffer
keymap("n", "<C-d>", ":bd!<CR>")
keymap("n", "<C-S-d>", ":<C-U>bprevious <bar> bdelete #<CR>") -- and move to previous buffer
keymap("n", "<C-q>", ":qa!<CR>")                              -- close all buffers and exit

-- toggle auto-indenting for code paste
keymap("n", "<F2>", ":set invpaste paste?<CR>")
vim.opt.pastetoggle = "<F2>"

-- clear search highlighting
keymap("n", "<leader>h", ":nohl<CR>")

-- quick save
keymap({ "n", "i" }, "<C-s>", "<cmd>w<CR>")
keymap({ "n", "i" }, "<C-S-s>", "<cmd>wa<CR>")

-- quickfix list
keymap("n", "<leader>co", ":copen<CR>")
keymap("n", "<leader>cw", ":cclose<CR>")
keymap("n", "<leader>cc", ":call setqflist([])<CR>") -- clear list

-- move visual block up/down
keymap("x", "J", ":move '>+1<CR>gv-gv")
keymap("x", "K", ":move '<-2<CR>gv-gv")
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv")
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv")

-----------------------------------------
-- plugins
-----------------------------------------

pcall(require, "plugins")

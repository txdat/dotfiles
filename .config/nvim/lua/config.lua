local opt = vim.opt
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- disable built-in plugins
local built_in_plugins = {
    "tutor",
    "tohtml",
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "zipPlugin",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "matchparen",
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

opt.compatible = false
-- opt.clipboard = "unnamed,unnamedplus" -- system"s clipboard
opt.clipboard = "unnamedplus" -- system"s clipboard
opt.timeout = true
opt.timeoutlen = 300          -- key mappings timeout
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.completeopt = "menu,menuone,noinsert,noselect" -- insert mode
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.mouse = "a" -- enable mouse support
opt.errorbells = false
opt.belloff = "all"
opt.modelines = 2
opt.wildmode = "longest,list"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- spelling
-- opt.spelllang = "en_us"
-- opt.spell = true

-----------------------------------------
-- gui
-----------------------------------------

opt.background = "dark"
opt.shortmess:append "sI"            -- disable nvim intro
opt.laststatus = 2                   -- set global statusline
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
opt.signcolumn = "auto"
opt.fillchars = [[eob: ,fold: ,foldopen:-,foldsep:│,foldclose:+]]
opt.foldcolumn = "1"
opt.statuscolumn = "%s%=%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''}%=%C%#IndentBlankLineChar"

-- statusline
function Statusline()
    return table.concat({
        "%1* " .. string.format("[%s]", vim.api.nvim_get_mode().mode):upper(), -- The current mode
        "%2* %<%f%m%r%h%w",                                                    -- File path, modified, readonly, helpfile, preview
        "%=",                                                                  -- Right side
        "%1* %l:%v %3p%%",                                                     -- Line:Col number, percentage of document
        -- "%2* %{''.(&fenc!=''?&fenc:&enc).''}",                                 -- Encoding
        -- "%3* (%{&ff})"                                                         -- FileFormat (dos/unix..)
    })
end

vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline()
  augroup END
]], false)

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
opt.history = 50      -- n lines in history
opt.lazyredraw = true -- faster scrolling
opt.synmaxcol = 240   -- max column for syntax highlight
opt.updatetime = 100  -- milli-seconds to wait for trigger an event (keymap)

-----------------------------------------
-- providers
-----------------------------------------

-- disable providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- python
vim.g.python3_host_prog = require("util").cmd("which python3")

-----------------------------------------
-- autocommand functions
-----------------------------------------

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
    -- command = ":%s/\\s\\+$//e"
    callback = function()
        local view = vim.fn.winsaveview()
        vim.cmd [[%s:\s\+$::e]]
        vim.fn.winrestview(view)
    end
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

-- keymap("n", "<ESC>", "<nop>")
-- keymap("i", "jj", "<ESC>")

-- remap recoding
keymap("n", "<A-q>", "q")
keymap("n", "q", "<nop>")

keymap("i", "<F1>", "<nop>")
keymap("n", "<F1>", ":set wrap!<CR>") -- toggle wrapping

-- toggle auto-indenting for code paste
keymap("n", "<F2>", ":set invpaste paste?<CR>")
opt.pastetoggle = "<F2>"

keymap("n", "<F3>", ":setlocal spell! spell?<CR>") -- toggle spelling
-- keymap("n", "<C-l>", "[s1z=<C-o>")
-- keymap("i", "<C-l>", "<C-g>u<ESC>[s1z=`]a<C-g>u")

keymap("n", "D", '"_dd') -- delete

keymap("n", "H", "^")
keymap("n", "L", "$")
keymap("n", "J", "10j")
keymap("n", "K", "10k")

keymap("n", "<A-v>", ":vsplit<CR>")

-- keymap("n", "<C-t>", ":Term<CR>")  -- open terminal
-- keymap("t", "<Esc>", "<C-\\><C-n>") -- exit without closing

-- switch tabs
keymap("n", "<A-[>", "gT")
keymap("n", "<A-]>", "gt")
keymap("n", "<A-\\>", ":tablast<CR>")

-- switch buffers
keymap("n", "<C-[>", ":bprevious<CR>")
keymap("n", "<C-]>", ":bnext<CR>")
keymap("n", "<C-\\>", ":b#<CR>") -- switch to last buffer

-- close current buffer
keymap("n", "<C-u>", "<nop>")
keymap("n", "<C-d>", ":bd!<CR>")
-- keymap("n", "<C-S-d>", ":<C-U>bprevious <bar> bdelete #<CR>") -- and move to previous buffer
keymap("n", "<C-q>", ":qa!<CR>") -- close all buffers and exit

-- clear search highlighting
keymap("n", "<ESC>", ":nohl<CR>")

-- quick save
keymap({ "n", "i" }, "<C-s>", "<cmd>w<CR>")
keymap({ "n", "i" }, "<C-S-s>", "<cmd>wa<CR>")

-- quickfix list
keymap("n", "co", ":copen<CR>")
keymap("n", "cw", ":cclose<CR>")
keymap("n", "cc", ":call setqflist([])<CR>") -- clear list
keymap("n", "]c", ":cnext<CR>")
keymap("n", "[c", ":cprev<CR>")

-- move visual block up/down
-- keymap("x", "J", ":move '>+1<CR>gv-gv")
-- keymap("x", "K", ":move '<-2<CR>gv-gv")

-- multicursor replacing
keymap("n", "<A-r>", function()
    vim.api.nvim_command "norm! yiw"
    vim.fn.setreg("/", vim.fn.getreg "+")
    vim.api.nvim_feedkeys("ciw", "n", false)
end)
keymap("v", "<A-r>", [[y/\V<C-R>=escape(@",'/\')<CR><CR>Ncgn]])

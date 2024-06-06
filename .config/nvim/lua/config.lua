local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- disable builtin plugins
local builtin_plugins = {
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

for _, plugin in ipairs(builtin_plugins) do
    vim.g["loaded_" .. plugin] = 1
end

-- disable deprecated messages
---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function() end

-----------------------------------------
-- general
-----------------------------------------

vim.opt.compatible = false
-- vim.opt.clipboard = "unnamed,unnamedplus" -- system"s clipboard
vim.opt.timeout = true
vim.opt.timeoutlen = 300 -- key mappings timeout
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.completeopt = "menu,menuone,noinsert,noselect" -- insert mode
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.mouse = "a" -- enable mouse support
vim.opt.errorbells = false
vim.opt.belloff = "all"
vim.opt.modelines = 2
vim.opt.wildmode = "longest,list"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- spelling
-- vim.opt.spelllang = "en_us"
-- vim.opt.spell = true

-----------------------------------------
-- gui
-----------------------------------------

vim.opt.background = "dark"
vim.opt.termguicolors = true             -- enable 24bits colors
vim.opt.shortmess:append "sI"            -- disable nvim intro
vim.opt.laststatus = 2                   -- set global statusline
vim.opt.guicursor = "n-v-c:block-Cursor" -- using block cursor
vim.opt.guicursor:append "i:block-iCursor"
vim.opt.guicursor:append "n-v-c:blinkon0"
vim.opt.guicursor:append "i:blinkon0"
-- vim.opt.colorcolumn = "80"
-- vim.opt.ruler = true  -- show cursor position
vim.opt.list = true           -- show eol, ...
vim.opt.cursorline = true
vim.opt.number = true         -- show line number
vim.opt.relativenumber = true -- (-1,+1) line number
vim.opt.showmatch = true      -- highlight matching parenthesis
vim.opt.foldmethod = "marker" -- enable folding
vim.opt.splitright = true     -- vertical split to the right
vim.opt.splitbelow = true     -- horizontal split to the bottom
vim.opt.signcolumn = "auto"
vim.opt.fillchars = [[eob: ,fold: ,foldopen:-,foldsep:│,foldclose:+]]
vim.opt.foldcolumn = "1"
vim.opt.statuscolumn = "%s%=%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''}%=%C%#IndentBlankLineChar"

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

---@diagnostic disable-next-line: deprecated
vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline()
  augroup END
]], false)

-----------------------------------------
-- tabs, indent, ...
-----------------------------------------

vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.expandtab = true -- use spaces instead of tab
vim.opt.tabstop = 4      -- 1 tab = 4 spaces
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 4   -- shifts 4 spaces when using tab
vim.opt.shiftround = true
vim.opt.linebreak = true -- wrap on word boundary
vim.opt.textwidth = 0

-----------------------------------------
-- searching
-----------------------------------------

vim.opt.hlsearch = true   -- highlight search result
vim.opt.incsearch = true  -- show first match when start typing
vim.opt.ignorecase = true -- ignore case sensitive when searching
vim.opt.smartcase = true  -- ignore lowercase for the whole pattern

-----------------------------------------
-- cpu, memory
-----------------------------------------

vim.opt.hidden = true     -- enable background buffers
vim.opt.history = 50      -- n lines in history
vim.opt.lazyredraw = true -- faster scrolling
vim.opt.synmaxcol = 240   -- max column for syntax highlight
vim.opt.updatetime = 100  -- milli-seconds to wait for trigger an event (keymap)

-----------------------------------------
-- providers
-----------------------------------------

-- disable providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- python
vim.g.python3_host_prog = require("util").system_cmd("which python3")

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

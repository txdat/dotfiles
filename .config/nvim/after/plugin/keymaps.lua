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
-- vim.opt.pastetoggle = "<F2>"

keymap("n", "<F3>", ":setlocal spell! spell?<CR>") -- toggle spelling
-- keymap("n", "<C-l>", "[s1z=<C-o>")
-- keymap("i", "<C-l>", "<C-g>u<ESC>[s1z=`]a<C-g>u")

keymap("n", "DD", '"_dd') -- delete

keymap("n", "H", "^")
keymap("n", "L", "$")
keymap("n", "J", "<C-d>")
keymap("n", "K", "<C-u>")

keymap("n", "<A-v>", ":vsplit<CR>")

-- keymap("n", "<C-t>", ":Term<CR>")  -- open terminal
-- keymap("t", "<Esc>", "<C-\\><C-n>") -- exit without closing

-- switch tabs
keymap("n", "[t", "gT")
keymap("n", "]t", "gt")
keymap("n", "\\t", ":tablast<CR>")

-- switch buffers
keymap("n", "[b", ":bprevious<CR>")
keymap("n", "]b", ":bnext<CR>")
keymap("n", "\\b", ":b#<CR>") -- switch to last buffer

-- close current buffer
keymap("n", "<C-u>", "<nop>")
keymap("n", "<C-d>", ":bd!<CR>")
-- keymap("n", "<C-S-d>", ":<C-U>bprevious <bar> bdelete #<CR>") -- and move to previous buffer
keymap("n", "<C-q>", ":qa!<CR>") -- close all buffers and exit

-- clear search highlighting
keymap("n", "<ESC>", ":nohl<CR>")

-- quick save
keymap({ "n", "i" }, "<C-s>", "<cmd>w<CR>")
-- keymap({ "n", "i" }, "<C-S-s>", "<cmd>wa<CR>")

-- quickfix list
keymap("n", "qo", ":copen<CR>")
keymap("n", "qq", ":cclose<CR>")
keymap("n", "qc", ":call setqflist([])<CR>") -- clear list
keymap("n", "]q", ":cnext<CR>")
keymap("n", "[q", ":cprev<CR>")

-- search yanked text
keymap("v", "//", "\"fy/\\V<C-R>f<CR>")
-- paste yanked text to terminal (ie. fzf)
keymap("t", "<C-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })

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

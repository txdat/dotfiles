local keymap = require("util").keymap

-- remap recoding
keymap("n", "<leader>q", "q")
keymap("n", "q", "<nop>")

-- keymap("n", "<C-t>", ":Term<CR>")  -- open terminal
-- keymap("t", "<Esc>", "<C-\\><C-n>") -- exit without closing

-- switch buffers
keymap("n", "<C-[>", ":bprevious<CR>")
keymap("n", "<C-]>", ":bnext<CR>")
keymap("n", "<C-\\>", ":b#<CR>")

-- close current buffer
keymap("n", "<C-d>", ":bd!<CR>")
keymap("n", "<C-S-d>", ":<C-U>bprevious <bar> bdelete #<CR>") -- and move to previous buffer
keymap("n", "<C-q>", ":qa!<CR>") -- close all buffers and exit

-- toggle auto-indenting for code paste
keymap("n", "<F2>", ":set invpaste paste?<CR>")
vim.opt.pastetoggle = "<F2>"

-- clear search highlighting
keymap("n", "<leader>h", ":nohl<CR>")

-- quick save
keymap("n", "<C-s>", ":w<CR>")
keymap("i", "<C-s>", "<C-c>:w<CR>")
keymap("n", "<C-S-s>", ":wa<CR>")

-- quickfix list
keymap("n", "<leader>co", ":copen<CR>")
keymap("n", "<leader>cw", ":cclose<CR>")
keymap("n", "<leader>cc", ":call setqflist([])<CR>") -- clear list

-- move visual block up/down
keymap("x", "J", ":move '>+1<CR>gv-gv")
keymap("x", "K", ":move '<-2<CR>gv-gv")
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv")
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv")

-- compile and run *.cpp
keymap("n", "<leader>r", ":!g++ -std=c++20 -DDEBUG -g % && ./a.out<CR>")

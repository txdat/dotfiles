local keymap = require ('util').keymap

keymap('n', '<C-t>', ':Term<CR>')  -- open terminal
keymap('t', '<Esc>', '<C-\\><C-n>')  -- exit without closing

-- switch buffers
keymap('n', '<C-[>', ':bprevious<CR>')
keymap('n', '<C-]>', ':bnext<CR>')

-- close current buffer
keymap('n', '<C-d>', ':bd!<CR>')
keymap('n', '<C-q>', ':<C-U>bprevious <bar> bdelete #<CR>')  -- and move to previous buffer
keymap('n', '<C-Q>', ':qa!<CR>')  -- close all buffers and exit

-- toggle auto-indenting for code paste
keymap('n', '<F2>', ':set invpaste paste?<CR>')
vim.opt.pastetoggle = '<F2>'

-- clear search highlighting
keymap('n', '<leader>nh', ':nohl<CR>')

-- quick save
keymap('n', '<C-s>', ':w<CR>')
keymap('i', '<C-s>', '<C-c>:w<CR>')

-- clear quickfix list
keymap('n', '<leader>ql', ':call setqflist([])<CR>')

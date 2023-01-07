local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- set <leader> key
vim.g.mapleader = '/'

----------------------------------
-- keymaps
----------------------------------

-- disable arrow keys
--map('', '<up>', '<nop>')
--map('', '<down>', '<nop>')
--map('', '<left>', '<nop>')
--map('', '<right>', '<nop>')

map('n', '<C-t>', ':Term<CR>') -- open terminal
map('t', '<Esc>', '<C-\\><C-n>') -- exit without closing

-- switch buffers
map('n', '<C-[>', ':bprevious<CR>')
map('n', '<C-]>', ':bnext<CR>')

-- close current buffer
map('n', '<C-d>', ':bd!<CR>')
map('n', '<C-q>', ':<C-U>bprevious <bar> bdelete #<CR>') -- and move to previous buffer
map('n', '<C-Q>', ':qa!<CR>') -- close all buffers and exit

-- toggle auto-indenting for code paste
map('n', '<F2>', ':set invpaste paste?<CR>')
vim.opt.pastetoggle = '<F2>'

-- clear search highlighting
map('n', '<leader>h', ':nohl<CR>')

-- quick save
map('n', '<C-s>', ':w<CR>')
map('i', '<C-s>', '<C-c>:w<CR>')

-- clear quickfix list
map('n', '<leader>l', ':call setqflist([])<CR>')

----------------------------------
-- plugins' keymaps
----------------------------------

-- chadtree
--map('n', '<C-e>', ':CHADopen<CR>')

-- nvim-tree
map('n', '<C-e>', ':NvimTreeToggle<CR>')

-- trouble
map('n', '<leader>tr', ':TroubleToggle<CR>')

-- telescope
map('n', '<leader>ff', ':Telescope find_files<CR>') -- find files by name
map('n', '<leader>fg', ':Telescope live_grep<CR>') -- find text in multiple files
map('n', '<leader>fb', ':Telescope buffers<CR>') -- find buffers

-- fzf-lua
map('n', '<leader>fz', ':FzfLua grep<CR>') -- Grep For...

-- dap

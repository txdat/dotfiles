local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- set <leader> key
vim.g.mapleader = ','

----------------------------------
-- keymaps
----------------------------------

-- disable arrow keys
--map('', '<up>', '<nop>')
--map('', '<down>', '<nop>')
--map('', '<left>', '<nop>')
--map('', '<right>', '<nop>')

-- clear search highlighting
map('n', '<leader>c', ':nohl<CR>')

-- toggle auto-indenting for code paste
map('n', '<F2>', ':set invpaste paste?<CR>')
vim.opt.pastetoggle = '<F2>'

-- fast saving
map('n', '<leader>s', ':w<CR>')
map('i', '<leader>s', '<C-c>:w<CR>')

-- terminal
map('n', '<C-t>', ':Term<CR>', { noremap = true }) -- open
map('t', '<Esc>', '<C-\\><C-n>')                   -- exit without closing buffer

-- change split orientation
map('n', '<leader>tk', '<C-w>t<C-w>K') -- change vertical to horizontal
map('n', '<leader>th', '<C-w>t<C-w>H') -- change horizontal to vertical

-- move around splits
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- switch buffers
map('n', '<C-[>', ':bprevious<CR>')
map('n', '<C-]>', ':bnext<CR>')

-- close current buffer
map('n', '<C-d>', ':bd!<CR>')
map('n', '<C-q>', ':<C-U>bprevious <bar> bdelete #<CR>')

-- close all windows and exit neovim
map('n', '<leader>q', ':qa!<CR>')

----------------------------------
-- plugins' keymaps
----------------------------------

-- CHADtree
map('n', '<leader>v', ':CHADopen<CR>', { noremap = true })
map('n', '<leader>l', 'call setqflist([])', { noremap = true })

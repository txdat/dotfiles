-- nvim's system/plugins' keymaps

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
-- nvim's system keymaps
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

-- terminal
map('n', '<C-t>', ':Term<CR>', { noremap = true }) -- open
map('t', '<Esc>', '<C-\\><C-n>')                   -- escape to normal mode
map('n', '<C-d>', ':bd!<CR>', { noremap = true })  -- exit

-- change split orientation
map('n', '<leader>tk', '<C-w>t<C-w>K') -- change vertical to horizontal
map('n', '<leader>th', '<C-w>t<C-w>H') -- change horizontal to vertical

-- move around splits
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- switch buffers
map('n', '<leader>[', ':bprevious<CR>')
map('n', '<leader>]', ':bnext<CR>')

-- close current buffer
map('n', '<leader>q', ':<C-U>bprevious <bar> bdelete #<CR>')

----------------------------------
-- nvim's plugins keymaps
----------------------------------

-- CHADtree
map('n', '<leader>v', ':CHADopen<CR>')

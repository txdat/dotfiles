require ('lspsaga').init_lsp_saga()

local keymap = require ('util').keymap

keymap('n', '<leader>ol', ':Lspsaga outline<CR>')
keymap('n', '<leader>lf', ':Lspsaga lsp_finder<CR>')
keymap('n', '<leader>ca', ':Lspsaga code_action<CR>')
keymap('n', '<leader>rn', ':Lspsaga rename<CR>')
keymap('n', '<leader>gd', ':Lspsaga peek_definition<CR>')  -- jump to definition
keymap('n', '<leader>ld', ':Lspsaga show_line_diagnostics<CR>')
keymap('n', '<leader>cd', ':Lspsaga show_cursor_diagnostics<CR>')

local lsp_diagnostic = require ('lspsaga.diagnostic')
keymap('n', '[d', ':Lspsaga diagnostic_jump_prev<CR>')
keymap('n', ']d', ':Lspsaga diagnostic_jump_next<CR>')
keymap('n', '[e', function()
    lsp_diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)
keymap('n', ']e', function()
    lsp_diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end)

keymap('n', '<A-k>', ':Lspsaga hover_doc<CR>')

-- Float terminal
-- keymap('n', '<A-f>', ':Lspsaga open_floaterm<CR>')
keymap('n', '<A-f>', ':Lspsaga open_floaterm lazygit<CR>')
-- close floaterm
keymap('t', '<A-f>', [[<C-\><C-n>:Lspsaga close_floaterm<CR>]])

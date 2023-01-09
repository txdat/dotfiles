-- select 1 of 4
-- require ('plugins.lsp.mason_lspconfig')
-- require ('plugins.lsp.lsp_zero')  -- disable lspsaga
require ('plugins.lsp.cmp')
-- require ('plugins.lsp.coq')

require ('plugins.lsp.lspsaga')
require ('plugins.lsp.null_ls')

-- diagnostic signs
local signs = {
    Error = ' ',
    Warning = ' ',
    Hint = ' ',
    Information = ' '
}

for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

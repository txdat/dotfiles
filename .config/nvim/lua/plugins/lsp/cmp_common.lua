local M = {}

M.sources = {
    { name = 'nvim_lsp', keyword_length = 3 },
    { name = 'buffer', keyword_length = 3 },
    { name = 'path' },
    { name = 'luasnip', keyword_length = 3 },
}

M.on_attach = function(_, bufnr)
    --local keymap = require ('util').keymap

    --local opts = { buffer = bufnr }
    --
    --keymap('n', 'gD', vim.lsp.buf.declaration, opts)
    --keymap('n', 'gd', vim.lsp.buf.definition, opts)
    --keymap('n', 'K', vim.lsp.buf.hover, opts)
    --keymap('n', 'gi', vim.lsp.buf.implementation, opts)
    --keymap('n', '<leader>sh', vim.lsp.buf.signature_help, opts)
    --keymap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    --keymap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    --keymap('n', '<leader>wl', function()
    --    vim.inspect(vim.lsp.buf.list_workspace_folders())
    --end, opts)
    --keymap('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    --keymap('n', '<leader>rn', vim.lsp.buf.rename, opts)
    --keymap('n', 'gr', vim.lsp.buf.references, opts)
    --keymap('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    --keymap('n', '<leader>so', require ('telescope.builtin').lsp_document_symbols, opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require ('cmp_nvim_lsp').default_capabilities(capabilities)

M.capabilities = capabilities

return M

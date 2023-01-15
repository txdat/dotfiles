require("plugins.lsp.mason")
require("plugins.lsp.mason_lspconfig")

-- select 1 of 3
-- require ("plugins.lsp.lsp_zero")  -- disable lspsaga
require("plugins.lsp.cmp")
-- require ("plugins.lsp.coq")

require("plugins.lsp.lspsaga")
require("plugins.lsp.null_ls")

-- custom diagnostic signs
local signs = {
    Error = " ",
    Warn = " ",
    Info = " ",
    Hint = " ",
}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    virtual_text = {
        prefix = "🔥",
        source = true,
    },
})

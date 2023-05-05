-- pcall(require, "plugins.lsp.mason")
-- pcall(require, "plugins.lsp.mason_lspconfig")
-- pcall(require, "plugins.lsp.lspsaga")
-- pcall(require, "plugins.lsp.null_ls")

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

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        signs = true,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        -- virtual_text = false,
        virtual_text = {
            prefix = "",
            source = "if_many",
            spacing = 5,
            severity_limit = 'Warning',
        },
    }
)

-- lsp windows border
require("lspconfig.ui.windows").default_options.border = "none"

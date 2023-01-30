pcall(require, "plugins.lsp.mason")
pcall(require, "plugins.lsp.mason_lspconfig")

-- select 1 of 3
-- pcall(require, "plugins.lsp.lsp_zero")
pcall(require, "plugins.lsp.cmp")
-- pcall(require, "plugins.lsp.coq")

-- pcall(require, "plugins.lsp.lsp_signature")
pcall(require, "plugins.lsp.lspsaga")
pcall(require, "plugins.lsp.null_ls")

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
        prefix = "",
        source = true,
    },
})

-- lsp windows border
require("lspconfig.ui.windows").default_options.border = "single"

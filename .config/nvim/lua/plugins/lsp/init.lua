pcall(require, "plugins.lsp.mason")
pcall(require, "plugins.lsp.mason_lspconfig")
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
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    virtual_text = {
        prefix = "",
        source = true,
    },
})

-- lsp windows border
require("lspconfig.ui.windows").default_options.border = "single"

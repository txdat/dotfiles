local mason_lsp = require("mason-lspconfig")

local lsp_servers = require("plugins.lsp.lsp_servers").ensure_installed

mason_lsp.setup({
    ensure_installed = lsp_servers,
    automatic_installation = false,
})

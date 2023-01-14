local mason_lsp = require("mason-lspconfig")

local lsp_servers = require("plugins.lsp.lsp_servers")

mason_lsp.setup({
    ensure_installed = lsp_servers.ensure_installed,
    automatic_installation = false,
})

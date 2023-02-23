local mason_lsp = require("mason-lspconfig")

mason_lsp.setup({
    ensure_installed = {
        "lua_ls",
    },
    automatic_installation = false,
})

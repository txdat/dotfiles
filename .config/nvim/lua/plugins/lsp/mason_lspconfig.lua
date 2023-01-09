local lspconfig = require ('lspconfig')
local mason_lsp = require ('mason-lspconfig')

local lsp_servers = require ('plugins.lsp.lsp_servers')

mason_lsp.setup({
    ensure_installed = lsp_servers.ensure_installed,
    automatic_installation = false,
})

local cmp_common = require ('plugins.lsp.cmp_common')

mason_lsp.setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({
            on_attach = cmp_common.on_attach,
            capabilities = cmp_common.capabilities,
        })
    end,
})

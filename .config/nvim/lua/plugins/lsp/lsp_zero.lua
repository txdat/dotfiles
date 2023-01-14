vim.opt.signcolumn = "yes"

local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.set_preferences({
    suggest_lsp_servers = false,
    setup_servers_on_start = true,
    set_lsp_keymaps = true,
    configure_diagnostics = true,
    cmp_capabilities = true,
    manage_nvim_cmp = true,
    call_servers = "global",
    sign_icons = {
        error = "",
        warn = "",
        hint = "",
        info = "",
    }
})

local cmp_common = require("plugins.lsp.cmp_common")

lsp.setup_nvim_cmp({
    documentation = {
        border = "single",
    },
    sources = cmp_common.sources,
})

lsp.extend_lspconfig()

local lsp_servers = require("plugins.lsp.lsp_servers")

lsp.ensure_installed(lsp_servers.ensure_installed) -- install with mason

for _, server in pairs(lsp_servers.servers) do
    lsp.configure(server, {
        force_setup = true, -- global server
        on_attach = cmp_common.on_attach,
        capabilities = cmp_common.capabilities,
    })
end

lsp.setup()

require("luasnip.loaders.from_vscode").lazy_load()

-- autopairs
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done()
)

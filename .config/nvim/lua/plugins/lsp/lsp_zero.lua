vim.opt.signcolumn = 'yes'

local lsp = require ('lsp-zero')

lsp.preset('recommended')

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = '',
        warn = '',
        hint = '',
        info = '',
    }
})

lsp.setup_nvim_cmp({
    documentation = {
        border = 'none',
    },
    sources = {
        { name = 'nvim_lsp', keyword_length = 3 },
        { name = 'buffer', keyword_length = 3 },
        { name = 'path' },
        { name = 'luasnip', keyword_length = 3 },
    }    
})

local lsp_servers = require ('plugins.lsp.lsp_servers')

--for _, server in pairs(lsp_servers) do
--    lsp.configure(server, {
--        force_setup = true, -- global server
--    })
--end

lsp.ensure_installed(lsp_servers)

lsp.setup()

require ('luasnip.loaders.from_snipmate').lazy_load()

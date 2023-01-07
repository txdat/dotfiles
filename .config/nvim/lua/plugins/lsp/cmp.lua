local cmp = require ('cmp')
local luasnip = require ('luasnip')
local lspconfig = require ('lspconfig')

cmp.setup {
    snippet = {
        expand = function(args)
        luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        --completion = cmp.config.window.bordered(),
        --documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            fallback()
        end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = 'nvim_lsp', keyword_length = 3 },
        { name = 'buffer', keyword_length = 3 },
        { name = 'path' },
        { name = 'luasnip', keyword_length = 3 },
    },
}

local lsp_capabilities = require ('cmp_nvim_lsp').default_capabilities()

local lsp_servers = require ('plugins.lsp.lsp_servers')
for _, server in pairs(lsp_servers) do
    lspconfig[server].setup {
        capabilities = lsp_capabilities
    }
end

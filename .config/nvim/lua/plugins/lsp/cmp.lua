-- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
-- https://miikanissi.com/blog/how-to-setup-nvim-lsp-for-code-analysis-autocompletion-and-linting/

local cmp = require('cmp')
local luasnip = require('luasnip')
local lspconfig = require('lspconfig')

local cmp_common = require('plugins.lsp.cmp_common')

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
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
    sources = cmp_common.sources,
}

local lsp_servers = require('plugins.lsp.lsp_servers').servers

for _, server in pairs(lsp_servers) do
    lspconfig[server].setup {
        on_attach = cmp_common.on_attach,
        capabilities = cmp_common.capabilities,
    }
end

require('luasnip.loaders.from_vscode').lazy_load()

-- autopairs
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)

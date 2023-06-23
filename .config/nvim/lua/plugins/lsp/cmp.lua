local cmp = require("cmp")
local compare = require("cmp.config.compare")
local luasnip = require("luasnip")

-- disable window's scroll
-- local cmp_window = require("cmp.utils.window")
--
-- cmp_window.info_ = cmp_window.info
-- cmp_window.info = function(self)
--     local info = self:info_()
--     info.scrollable = false
--     return info
-- end

-- -- lspkind on cmp's menu
-- local lspkind_icons = {
--     Text = "",
--     Method = "󰆧",
--     Function = "󰊕",
--     Constructor = "",
--     Field = "󰇽",
--     Variable = "󰂡",
--     Class = "󰠱",
--     Interface = "",
--     Module = "",
--     Property = "󰜢",
--     Unit = "",
--     Value = "󰎠",
--     Enum = "",
--     Keyword = "󰌋",
--     Snippet = "",
--     Color = "󰏘",
--     File = "󰈙",
--     Reference = "",
--     Folder = "󰉋",
--     EnumMember = "",
--     Constant = "󰏿",
--     Struct = "",
--     Event = "",
--     Operator = "󰆕",
--     TypeParameter = "󰅲",
-- }

local lspkind_menu = {
    nvim_lsp = "Lsp",
    luasnip = "Snp",
    buffer = "Buf",
};

vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

cmp.setup {
    completion = {
        completeopt = "menu,menuone,noinsert,noselect",
    },
    performance = {
        max_view_entries = 20,
    },
    experimental = {
        ghost_text = { hl_group = "CmpGhostText" }
    },
    view = {
        entries = { name = "native", selection_order = "near_cursor" },
    },
    window = {
        completion = {
            border = "none",
            winhighlight = "Normal:CmpNormal",
        },
        documentation = {
            border = "none",
            winhighlight = "Normal:CmpDocNormal",
        },
    },
    formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, vim_item)
            -- vim_item.kind = string.format('%s %s', lspkind_icons[vim_item.kind], vim_item.kind)
            vim_item.menu = string.format('[%s]', lspkind_menu[entry.source.name])
            return vim_item
        end
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.scroll_docs(-4),
        ["<C-j>"] = cmp.mapping.scroll_docs(4),
        -- ["<C-Space>"] = cmp.mapping.complete(),
        -- ["<Space>"] = cmp.mapping.abort(),
        ["<C-Space>"] = function() -- toggle completion
            if cmp.visible() then
                return cmp.close()
            end
            cmp.complete()
        end,
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = {
        { name = "nvim_lsp", keyword_length = 2, priority = 10 },
        { name = "buffer",   keyword_length = 2, priority = 8 },
        { name = "luasnip",  keyword_length = 2, priority = 7 },
        { name = "path",     keyword_length = 3 },
        -- { name = "nvim_lsp_signature_help" },
    },
    sorting = {
        priority_weight = 2,
        comparators = {
            compare.offset,    -- we still want offset to be higher to order after 3rd letter
            compare.score,     -- same as above
            compare.sort_text, -- add higher precedence for sort_text, it must be above `kind`
            compare.recently_used,
            compare.kind,
            compare.length,
            compare.order,
        },
    },
}

-- snippet
luasnip.config.set_config({
    history = false,
    update_events = "TextChanged,TextChangedI",
    delete_check_events = "TextChanged",
})

require("luasnip.loaders.from_vscode").lazy_load()

-- autopairs
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done()
)

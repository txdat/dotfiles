local highlight = vim.api.nvim_set_hl

-- highlight(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#949494' })
-- highlight(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#80a0ff' }) -- blue
-- highlight(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })
-- highlight(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#36c692' }) -- emerald
-- highlight(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
-- highlight(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
-- highlight(0, 'CmpItemKindFunction', { bg = 'NONE', fg = '#cf87e8' }) -- violet
-- highlight(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
-- highlight(0, 'CmpItemKindKeyword', { bg = 'NONE', fg = '#c6c6c6' }) -- front
-- highlight(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
-- highlight(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })

highlight(0, "CmpGhostText", { link = "Comment", default = true })

local cmp = require("cmp")
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
--     Array = "",
--     Boolean = "",
--     Class = "",
--     Color = "",
--     Constant = "",
--     Constructor = "",
--     Copilot = "",
--     Enum = "",
--     EnumMember = "",
--     Event = "",
--     Field = "",
--     File = "",
--     Folder = "",
--     Function = "",
--     Interface = "",
--     Key = "",
--     Keyword = "",
--     Method = "",
--     Module = "",
--     Namespace = "",
--     Null = "",
--     Number = "",
--     Object = "",
--     Operator = "",
--     Package = "",
--     Property = "",
--     Reference = "",
--     Snippet = "",
--     String = "",
--     Struct = "",
--     Text = "",
--     TypeParameter = "",
--     Unit = "",
--     Value = "",
--     Variable = "",
-- }

local lspkind_menu = {
    nvim_lsp = "lsp",
    luasnip = "snip",
    buffer = "buf",
    path = "fs",
};

cmp.setup({
    completion = {
        completeopt = "menuone,fuzzy,noinsert,noselect",
    },
    performance = {
        max_view_entries = 20,
    },
    experimental = {
        ghost_text = { hl_group = "CmpGhostText" }
    },
    view = {
        entries = { name = "native", selection_order = "near_cursor" },
        docs = {
            auto_open = false,
        },
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
            vim_item.menu = string.format('[%s]', lspkind_menu[entry.source.name] or entry.source.name)
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
        ["<C-l>"] = function() -- toggle documentation window
            if cmp.visible_docs() then
                cmp.close_docs()
            else
                cmp.open_docs()
            end
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
        {
            name = "buffer",
            keyword_length = 2,
            priority = 9,
            option = {
                get_bufnrs = function()
                    local bufs = {}
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        local buf = vim.api.nvim_win_get_buf(win);
                        -- local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                        -- if byte_size <= 5242880 then -- skip large buffer (> 5MB)
                        bufs[buf] = true
                        -- end
                    end
                    return vim.tbl_keys(bufs)
                end
            }
        },
        { name = "luasnip",  keyword_length = 2, priority = 8 },
        { name = "path",     keyword_length = 3, priority = 5 },
        -- { name = "nvim_lsp_signature_help" },
    },
    sorting = {
        priority_weight = 2,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,

            -- cmp-under
            function(entry1, entry2)
                local _, entry1_under = entry1.completion_item.label:find "^_+"
                local _, entry2_under = entry2.completion_item.label:find "^_+"
                entry1_under = entry1_under or 0
                entry2_under = entry2_under or 0
                if entry1_under > entry2_under then
                    return false
                elseif entry1_under < entry2_under then
                    return true
                end
            end,

            -- cmp.config.compare.locality,
            -- cmp.config.compare.kind,
            -- cmp.config.compare.sort_text,
            -- cmp.config.compare.length,
            -- cmp.config.compare.order,
        },
    },
})

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

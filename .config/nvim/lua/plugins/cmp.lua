local cmp = require("cmp")
local use_luasnip, luasnip = pcall(require, "luasnip")

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
  buffer = "bf",
  path = " fs",
  luasnip = "snp",
};

cmp.setup({
  completion = {
    completeopt = "menuone,noinsert,noselect",
  },
  performance = {
    max_view_entries = 20,
    debounce = 0,
    throttle = 0,
  },
  matching = {
    disallow_fuzzy_matching = true,
    disallow_fullfuzzy_matching = true,
    disallow_partial_fuzzy_matching = true,
    disallow_symbol_nonprefix_matching = true,
    disallow_partial_matching = false,
    disallow_prefix_unmatching = false,
  },
  experimental = {
    ghost_text = { hl_group = "Comment" }
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
    ["<C-p>"] = function() -- toggle documentation window
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
      elseif use_luasnip and luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif use_luasnip and luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  snippet = {
    expand = function(args)
      if use_luasnip then
        luasnip.lsp_expand(args.body)
      else
        vim.snippet.expand(args.body)
      end
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
      cmp.config.compare.kind,

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
      -- cmp.config.compare.sort_text,
      -- cmp.config.compare.length,
      -- cmp.config.compare.order,
    },
  },
})

-- autopairs
local use_autopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if use_autopairs then
  cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done()
  )
end

-- snippet
if use_luasnip then
  luasnip.config.set_config({
    history = false,
    update_events = "TextChanged,TextChangedI",
    delete_check_events = "TextChanged",
  })

  require("luasnip.loaders.from_vscode").lazy_load()
end

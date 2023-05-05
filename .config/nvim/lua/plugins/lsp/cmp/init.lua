-- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
-- https://miikanissi.com/blog/how-to-setup-nvim-lsp-for-code-analysis-autocompletion-and-linting/

local cmp = require("cmp")
local luasnip = require("luasnip")
local lspconfig = require("lspconfig")

-- disable window's scroll
-- local cmp_window = require("cmp.utils.window")
--
-- cmp_window.info_ = cmp_window.info
-- cmp_window.info = function(self)
--     local info = self:info_()
--     info.scrollable = false
--     return info
-- end

cmp.setup {
    completion = {
        completeopt = "menu,menuone,noinsert,noselect",
    },
    experimental = {
        ghost_text = true, -- placeholder
    },
    view = {
        entries = { name = "native", selection_order = "near_cursor" },
    },
    window = {
        completion = {
            border = "none",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        },
        documentation = {
            border = "none",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        },
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.scroll_docs(-4),
        ["<C-j>"] = cmp.mapping.scroll_docs(4),
        -- ["<C-Space>"] = cmp.mapping.complete(),
        -- ["<Space>"] = cmp.mapping.abort(),
        ["<C-Space>"] = function ()
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
        { name = "nvim_lsp", keyword_length = 2 },
        { name = "luasnip",  keyword_length = 2 },
        { name = "buffer",   keyword_length = 2 },
        { name = "path" },
        -- { name = "nvim_lsp_signature_help" },
    },
}

-- lsp servers config
-- on_attach
local keymap = require("util").keymap

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local lspbuf = vim.lsp.buf
        local diag = vim.diagnostic
        local opts = { buffer = args.buf }

        keymap("n", "K", lspbuf.hover, opts)
        keymap("n", "<F2>", lspbuf.rename, opts)
        keymap("n", "gd", lspbuf.definition, opts)
        keymap("n", "gD", lspbuf.declaration, opts)
        keymap("n", "gt", lspbuf.type_definition, opts)
        keymap("n", "gs", lspbuf.signature_help, opts)
        keymap("n", "gi", lspbuf.implementation, opts)
        keymap("n", "gr", lspbuf.references, opts)
        keymap("n", "gc", lspbuf.code_action, opts)
        keymap("n", "D", diag.open_float, opts)
        keymap("n", "d[", diag.goto_prev, opts)
        keymap("n", "d]", diag.goto_next, opts)
        keymap("n", "<C-i>", function()
            lspbuf.format { async = true }
        end, opts)
    end
})

-- local function on_attach(client, bufnr)
--     client.server_capabilities.documentFormattingProvider = true
-- end

-- capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- handlers
-- local handlers = {
--     ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
--         border = "none",
--         close_events = { "CursorMoved", "InsertLeave", "BufHidden" },
--         focusable = false,
--         use_existing = true,
--         silent = true,
--     }),
-- }

-- config
local servers_config = require("plugins.lsp.cmp.servers_config")

for server, config in pairs(servers_config) do
    config.capabilities = capabilities
    -- config.on_attach = on_attach
    -- config.handlers = handlers

    lspconfig[server].setup(config)
end

-- snippet
luasnip.config.set_config({
    history = false,
    updateevents = "TextChanged,TextChangedI",
})

require("luasnip.loaders.from_vscode").lazy_load()

-- autopairs
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done()
)

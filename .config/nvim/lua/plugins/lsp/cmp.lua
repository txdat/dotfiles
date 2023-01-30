-- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
-- https://miikanissi.com/blog/how-to-setup-nvim-lsp-for-code-analysis-autocompletion-and-linting/

local cmp = require("cmp")
local luasnip = require("luasnip")
local lspconfig = require("lspconfig")

-- disable window's scroll
local cmp_window = require("cmp.utils.window")

cmp_window.info_ = cmp_window.info
cmp_window.info = function(self)
    local info = self:info_()
    info.scrollable = false
    return info
end

cmp.setup {
    completion = {
        completeopt = "menu,menuone,noinsert,noselect",
    },
    experimental = {
        ghost_text = true, -- placeholder
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
        completion = {
            border = "single",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        },
        documentation = {
            border = "single",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        },
    },
    formatting = {
        fields = { "abbr", "kind", "menu" },
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.scroll_docs(-4),
        ["<C-j>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
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
        { name = "nvim_lsp", keyword_length = 3 },
        { name = "buffer", keyword_length = 3 },
        { name = "path" },
        -- { name = "nvim_lsp_signature_help" },
        { name = "luasnip", keyword_length = 3 },
    },
}

-- lsp servers config
-- on_attach
local keymap = require("util").keymap

local function on_attach(_, bufnr)
    local opts = { buffer = bufnr }

    keymap("n", "<A-s>", vim.lsp.buf.signature_help, opts)
end

-- capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- handlers
local handlers = {
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "single",
        close_events = { "CursorMoved", "InsertLeave", "BufHidden" },
        focusable = false,
        use_existing = true,
        silent = true,
    }),
}

-- config
local servers_config = require("plugins.lsp.lsp_servers").servers_config

for server, cfg in pairs(servers_config) do
    local config = {
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = handlers,
    }
    for k, v in pairs(cfg) do
        config[k] = v
    end

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

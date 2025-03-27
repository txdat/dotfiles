-- custom diagnostic signs
local signs = {
    Error = " ",
    Warn  = " ",
    Info  = " ",
    Hint  = " ",
}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- prevent LSP from overwriting treesitter color setting (< 100)
vim.highlight.priorities.semantic_tokens = 0

vim.diagnostic.config({
    update_in_insert = true,
    underline = false,
    severity_sort = true,
    signs = {
        severity = { min = vim.diagnostic.severity.ERROR },
    },
    virtual_text = {
        severity = { min = vim.diagnostic.severity.ERROR },
        spacing = 5,
    },
    float = {
        severity = { min = vim.diagnostic.severity.ERROR },
        border = "none",
    },
})

-- lsp servers config
local keymap = require("util").keymap

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local lspbuf = vim.lsp.buf
        local diag = vim.diagnostic
        local opts = { buffer = args.buf }

        keymap("n", "gh", lspbuf.hover, opts)
        keymap("n", "gn", lspbuf.rename, opts)
        keymap("n", "gd", lspbuf.definition, opts)
        keymap("n", "gdc", lspbuf.declaration, opts)
        keymap("n", "gt", lspbuf.type_definition, opts)
        keymap("n", "gs", lspbuf.signature_help, opts)
        keymap("n", "gi", lspbuf.implementation, opts)
        keymap("n", "gr", lspbuf.references, opts)
        keymap("n", "ga", lspbuf.code_action, opts)
        -- keymap("n", "ga", function()
        --     require("fzf-lua").lsp_code_actions()
        -- end, opts)
        keymap("n", "gf", diag.open_float, opts)
        -- keymap("n", "[d", diag.goto_prev, opts)
        -- keymap("n", "]d", diag.goto_next, opts)
        keymap("n", "[e", function()
            diag.goto_prev({ severity = diag.severity.ERROR })
        end, opts)
        keymap("n", "]e", function()
            diag.goto_next({ severity = diag.severity.ERROR })
        end, opts)
        keymap({ "n", "v" }, "<C-i>", function()
            require("conform").format({ bufnr = args.buf, async = true, lsp_fallback = true })
        end, opts)
    end
})

-- attach lsp's servers
local lspconfig = require("lspconfig")

-- lsp windows border
require("lspconfig.ui.windows").default_options.border = "none"

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- local function on_attach(client, bufnr)
-- end

-- local handlers = {
--     ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
--         border = "none",
--         close_events = { "CursorMoved", "InsertLeave", "BufHidden" },
--         focusable = false,
--         use_existing = true,
--         silent = true,
--     }),
-- }

local lsp_servers = require("plugins.lsp.servers")

for server, config in pairs(lsp_servers) do
    config.capabilities = capabilities
    -- config.on_attach = on_attach
    -- config.handlers = handlers

    lspconfig[server].setup(config)
end

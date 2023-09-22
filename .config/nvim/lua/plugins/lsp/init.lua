-- pcall(require, "plugins.lsp.mason")
-- pcall(require, "plugins.lsp.mason_lspconfig")
-- pcall(require, "plugins.lsp.lspsaga")
-- pcall(require, "plugins.lsp.null_ls")
pcall(require, "plugins.lsp.trouble")

-- custom diagnostic signs
local signs = {
    Error = " ",
    Warn = " ",
    Info = " ",
    Hint = " ",
}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        signs = true,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        virtual_text = {
            -- prefix = "",
            source = "if_many",
            spacing = 5,
            severity_limit = 'Warning',
        },
    }
)

-- lsp windows border
require("lspconfig.ui.windows").default_options.border = "none"

-- asynchronous formatting
-- https://www.reddit.com/r/neovim/comments/14iqm8t/my_setup_for_responsive_immutable_formatting/
-- TODO: fix without lsp
-- local function apply_formatting(bufnr, result, client_id)
--     vim.bo[bufnr].modifiable = true
--     if not result then
--         return
--     end
--
--     local client = vim.lsp.get_client_by_id(client_id)
--     vim.lsp.util.apply_text_edits(result, bufnr, client.offset_encoding)
--     if vim.b[bufnr].write_after_format then
--         vim.cmd("let buf = bufnr('%') | exec '" .. bufnr .. "bufdo :noa w' | exec 'b' buf")
--     end
--     vim.b[bufnr].write_after_format = nil
-- end
--
-- vim.lsp.handlers["textDocument/formatting"] = function(_, result, ctx, _)
--     apply_formatting(ctx.bufnr, result, ctx.client_id)
-- end
--
-- local function format_async(bufnr, write_after)
--     vim.bo[bufnr].modifiable = false
--     vim.b[bufnr].write_after_format = write_after
--     vim.lsp.buf.format({ async = true })
-- end

-- lsp servers config
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
        keymap("n", "D[", function()
            diag.goto_prev({ severity = diag.severity.ERROR })
        end, opts)
        keymap("n", "D]", function()
            diag.goto_next({ severity = diag.severity.ERROR })
        end, opts)
        keymap("n", "<C-i>", function()
            lspbuf.format { async = true }
            -- format_async(args.buf, true)
        end, opts)
    end
})

-- on attach
-- local function on_attach(client, bufnr)
--     -- disable tsserver document formatting
--     if client.name == "tsserver" then
--         client.server_capabilities.documentFormattingProvider = false
--     else
--         client.server_capabilities.documentFormattingProvider = true
--     end
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

-- attach lsp servers
local lspconfig = require("lspconfig")
local servers = require("plugins.lsp.servers")
for server, config in pairs(servers) do
    config.capabilities = capabilities
    -- config.on_attach = on_attach
    -- config.handlers = handlers

    lspconfig[server].setup(config)
end

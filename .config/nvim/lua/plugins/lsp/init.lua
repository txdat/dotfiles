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
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        signs = {
            severity_limit = 'Error',
        },
        virtual_text = {
            -- prefix = "",
            source = "if_many",
            spacing = 5,
            severity_limit = 'Error',
        },
    }
)

-- lsp windows border
require("lspconfig.ui.windows").default_options.border = "none"

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
        keymap("n", "gc", lspbuf.declaration, opts)
        keymap("n", "gt", lspbuf.type_definition, opts)
        keymap("n", "gs", lspbuf.signature_help, opts)
        keymap("n", "gi", lspbuf.implementation, opts)
        keymap("n", "gr", lspbuf.references, opts)
        keymap("n", "ga", lspbuf.code_action, opts)
        -- keymap("n", "gc", function()
        --     require("fzf-lua").lsp_code_actions()
        -- end, opts)
        keymap("n", "gD", diag.open_float, opts)
        -- keymap("n", "[d", diag.goto_prev, opts)
        -- keymap("n", "]d", diag.goto_next, opts)
        keymap("n", "[d", function()
            diag.goto_prev({ severity = diag.severity.ERROR })
        end, opts)
        keymap("n", "]d", function()
            diag.goto_next({ severity = diag.severity.ERROR })
        end, opts)
        keymap({ "n", "v" }, "<C-i>", function()
            require("conform").format({ bufnr = args.buf, async = true, lsp_fallback = true })
        end, opts)
    end
})

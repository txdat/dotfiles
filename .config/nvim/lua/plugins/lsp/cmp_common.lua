local keymap = require("util").keymap

local M = {}

M.sources = {
    { name = "nvim_lsp", keyword_length = 3 },
    { name = "buffer", keyword_length = 3 },
    { name = "path" },
    { name = "luasnip", keyword_length = 3 },
}

M.on_attach = function(_, bufnr)
    -- keymap
    local opts = { buffer = bufnr }

    keymap("n", "<A-s>", vim.lsp.buf.signature_help, opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

M.capabilities = capabilities

-- lsp handlers
local border = {
    { "┌", "FloatBorder" },
    { "─", "FloatBorder" },
    { "┐", "FloatBorder" },
    { "│", "FloatBorder" },
    { "┘", "FloatBorder" },
    { "─", "FloatBorder" },
    { "└", "FloatBorder" },
    { "│", "FloatBorder" },
}

M.handlers = {
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

return M

local conform = require("conform")

conform.setup({
    default_format_opts = { lsp_format = "fallback" },
    formatters_by_ft = {
        python = { "black" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        json = { "prettierd" },
        markdown = { "prettierd" },
    },
    log_level = vim.log.levels.ERROR,
})

local keymap = require("util").keymap

keymap({ "n", "v" }, "<C-i>", function()
    conform.format({ async = true, lsp_fallback = true })
end)

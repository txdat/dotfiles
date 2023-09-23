require("conform").setup({
    formatters_by_ft = {
        python = { "black" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
    },
    log_level = vim.log.levels.ERROR,
})

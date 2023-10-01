require("conform").setup({
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

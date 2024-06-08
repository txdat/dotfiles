require("modus-themes").setup({
    style = "auto",
    variant = "default",
    transparent = false,
    dim_inactive = false,
    hide_inactive_statusline = false,
    styles = {
        comments = { italic = false },
        keywords = { italic = false },
        functions = {},
        variables = {},
    }
})

vim.cmd("colorscheme modus")

require("tokyonight").setup({
    style = "night",
    styles = {
        comments = {},
        keywords = {},
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
    },
    sidebars = { "qf", "help", "terminal" },
})

vim.cmd("colorscheme tokyonight-night")

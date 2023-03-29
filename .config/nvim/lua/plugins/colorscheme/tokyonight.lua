require("tokyonight").setup({
    style = "night",
    styles = {
        comments = { italic = false },
        keywords = { italic = false },
    },
    sidebars = {},
})

vim.cmd("colorscheme tokyonight-night")

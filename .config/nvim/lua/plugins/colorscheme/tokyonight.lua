require("tokyonight").setup({
    style = "night",
    transparent = false,
    terminal_colors = true,
    styles = {
        comments = { italic = false },
        keywords = { italic = false },
    },
})

vim.cmd("colorscheme tokyonight-night")

require("github-theme").setup({
    options = {
        styles = {
            comments = "NONE",
            keywords = "NONE",
        },
        darken = {
            floats = false,
            sidebars = { enable = false },
        }
    },
    palettes = {
        github_dark_high_contrast = {
            bg0 = '#080808',
            bg1 = '#080808',
            fg0 = '#b2b2b2',
            fg1 = '#b2b2b2',
        },
    },
})

vim.cmd("colorscheme github_dark_high_contrast")

require("github-theme").setup({
    options = {
        styles = {
            comments = "NONE",
            keywords = "NONE",
        },
        darken = {
            floats = true,
        }
    }
})

vim.cmd("colorscheme github_dark")

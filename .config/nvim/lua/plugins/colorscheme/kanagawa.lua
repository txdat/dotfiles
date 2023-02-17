vim.opt.fillchars:append({
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┨",
    vertright = "┣",
    verthoriz = "╋",
})

require("kanagawa").setup {
    globalStatus = true,
    colors = {
        sumiInk0 = "#0f111b",
        sumiInk1 = "#0f111b",
        fujiWhite = "#ecf0c1",
        oldWhite = "#ecf0c1",
    },
}

vim.cmd("colorscheme kanagawa")

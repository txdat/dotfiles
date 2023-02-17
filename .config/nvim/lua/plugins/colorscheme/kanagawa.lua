vim.opt.fillchars:append({
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┨",
    vertright = "┣",
    verthoriz = "╋",
})

-- spaceduck background
local custom_colors = {
    sumiInk0 = "#0f111b",
    sumiInk1 = "#0f111b",
    fujiWhite = "#ecf0c1",
    oldWhite = "#ecf0c1",
}

require("kanagawa").setup {
    colors = custom_colors,
    theme = "default" -- Load "default" theme or the experimental "light" theme
}

vim.cmd("colorscheme kanagawa")

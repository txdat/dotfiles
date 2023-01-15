vim.opt.fillchars:append({
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┨",
    vertright = "┣",
    verthoriz = "╋",
})

local custom_colors = {
    -- sumiInk0 = "#161616", -- oxocarbon background
    sumiInk0 = "#0f111b", -- spaceduck background
    sumiInk1 = "#0f111b",
    fujiWhite = "#ecf0c1", -- spaceduck foreground
    oldWhite = "#ecf0c1",
}

require("kanagawa").setup {
    undercurl = true, -- enable undercurls
    commentStyle = { italic = false },
    functionStyle = {},
    keywordStyle = { italic = false },
    statementStyle = { bold = false },
    typeStyle = {},
    variablebuiltinStyle = { italic = false },
    specialReturn = true, -- special highlight for the return keyword
    specialException = true, -- special highlight for exception handling keywords
    transparent = false, -- do not set background color
    dimInactive = false, -- dim inactive window `:h hl-NormalNC`
    globalStatus = true, -- adjust window separators highlight for laststatus=3
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    colors = custom_colors,
    overrides = {},
    theme = "default" -- Load "default" theme or the experimental "light" theme
}

vim.cmd("colorscheme kanagawa")

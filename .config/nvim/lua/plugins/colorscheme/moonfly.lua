vim.g.moonflyCursorColor = false
vim.g.moonflyItalics = false
vim.g.moonflyNormalFloat = true
vim.g.moonflyTerminalColors = true
vim.g.moonflyTransparent = false
vim.g.moonflyUndercurls = false
vim.g.moonflyUnderlineMatchParen = false
vim.g.moonflyVirtualTextColor = true
vim.g.moonflyWinSeparator = 0

require("moonfly").custom_colors({
    bg = "#000000",
})

vim.cmd("colorscheme moonfly")

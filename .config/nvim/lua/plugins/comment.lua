require("Comment").setup({
    toggler = {
        line = "<A-/>",
        block = "<A-?>",
    },
    opleader = {
        line = "<A-/>",
        block = "<A-?>",
    },
    extra = {
        above = "<A-/>k",
        below = "<A-/>j",
        eol = "<A-/>l",
    },
})

-- insert mode key binding
local api = require("Comment.api")
local keymap = require("util").keymap

keymap({ "n", "i" }, "<A-/>", api.toggle.linewise.current)

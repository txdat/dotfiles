require("Comment").setup({
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
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

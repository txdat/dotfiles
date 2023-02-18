require("sniprun").setup({
    display = {
        "TerminalWithCode",
    },
    live_display = {
        "TerminalWithCode",
    },
    display_options = {
        terminal_width = 100,
    },
    borders = 'single',
})

local keymap = require("util").keymap

keymap({ "n", "v" }, "<leader>rl", ":SnipRun<CR>")
keymap({ "n", "v" }, "<leader>rb", ":'<,'>SnipRun<CR>")
keymap("n", "<leader>rs", ":SnipReset<CR>")
keymap("n", "<leader>rc", ":SnipClose<CR>")

require("sniprun").setup({
    interpreter_options = {
        C_original = {
            compiler = "gcc -g",
            -- compiler = "clang --debug",
        },
        Cpp_original = {
            compiler = "g++ -std=c++20 -g",
            -- compiler = "clang++ -std=c++20 --debug",
        },
        Rust_original = {
            compiler = "rustc",
        },
        Go_original = {
            compiler = "go",
        },
        Python3_original = {
            interpreter = require("util").shell_cmd("which python3"),
        },
    },
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

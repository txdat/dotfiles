require('nvim-tree').setup {
    open_on_setup = false,
    ignore_buffer_on_setup = false,
    respect_buf_cwd = true,
    renderer = {
        group_empty = false,
        highlight_git = true,
        indent_width = 2,
        indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
                corner = "└",
                edge = "│",
                item = "│",
                bottom = "─",
                none = " ",
            },
        },
    },
    hijack_directories = {
        enable = true,
        auto_open = true,
    },
    view = {
        adaptive_size = false,
        width = 30,
        mappings = {
        },
    },
}

local keymap = require('util').keymap

keymap('n', '<C-e>', ':NvimTreeToggle<CR>')

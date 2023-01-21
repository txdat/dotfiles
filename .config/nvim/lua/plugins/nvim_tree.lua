require("nvim-tree").setup {
    hijack_cursor = true,
    hijack_directories = {
        enable = true,
        auto_open = true,
    },
    update_focused_file = {
        enable = true,
        update_cwd = true,
    },
    git = {
        enable = true,
    },
    filesystem_watchers = {
        enable = true,
    },
    view = {
        cursorline = true,
        hide_root_folder = true,
        width = 30,
    },
    renderer = {
        group_empty = true,
        highlight_git = true,
        highlight_modified = "all",
        root_folder_modifier = table.concat({ ":t:gs?$?/", string.rep(" ", 1000), "?:gs?^??" }),
        indent_width = 2,
        indent_markers = {
            enable = true,
        },
    },
    filters = {
        dotfiles = false,
        exclude = { ".git", "node_modules", "__pycache__" }
    }
}

local keymap = require("util").keymap

keymap("n", "<C-e>", ":NvimTreeToggle<CR>")

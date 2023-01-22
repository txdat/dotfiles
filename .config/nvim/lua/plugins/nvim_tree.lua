require("nvim-tree").setup {
    hijack_cursor = true,
    hijack_directories = {
        enable = true,
        auto_open = true,
    },
    update_focused_file = {
        enable = true,
        update_root = true,
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
        side = "left",
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
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        severity = {
            min = vim.diagnostic.severity.WARN,
            max = vim.diagnostic.severity.ERROR,
        },
        icons = { error = " ", warning = " ", info = " ", hint = " " },
    },
    filters = {
        dotfiles = false,
        custom = { "^.git$", "^.dvc$", "^__pycache__$", "^node_modules$" },
    }
}

local keymap = require("util").keymap

keymap("n", "<C-e>", ":NvimTreeToggle<CR>")

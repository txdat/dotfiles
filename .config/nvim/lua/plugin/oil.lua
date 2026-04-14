require("oil").setup({
    columns = { "icon" },
    win_options = {
        signcolumn = "yes",
    },
    skip_confirm_for_simple_edits = true,
    keymaps = {
        ["<ESC>"] = "actions.close",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_split",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-t>"] = "actions.select_tab",
        ["<C-r>"] = "actions.refresh",
        ["<C-p>"] = "actions.preview",
        ["<C-h>"] = "actions.toggle_hidden",
        ["<BS>"] = "actions.parent",
        ["/"] = "actions.open_cwd",
        ["."] = "actions.cd",
        [","] = "actions.tcd",
    },
    use_default_keymaps = false,
    view_options = {
        show_hidden = false,
    },
    float = {
        padding = 0,
        border = "none",
        win_options = {
            winblend = 0,
        },
    },
    preview = {
        max_width = 1.0,
        min_width = 0.5,
        max_height = 1.0,
        min_height = 0.5,
        border = "none",
        win_options = {
            winblend = 0,
        },
    },
    progress = {
        max_width = 1.0,
        min_width = 0.5,
        max_height = 1.0,
        min_height = 0.5,
        border = "none",
        minimized_border = "none",
        win_options = {
            winblend = 0,
        },
    },
})

local keymap = require("util").keymap

keymap("n", "<C-e>", ":Oil<CR>")

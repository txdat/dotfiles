require("nvim-tree").setup({
    hijack_cursor = true,
    hijack_directories = {
        enable = true,
        auto_open = true,
    },
    update_focused_file = {
        enable = false,
        update_root = false,
    },
    git = {
        enable = true,
    },
    filesystem_watchers = {
        enable = true,
    },
    view = {
        cursorline = true,
        hide_root_folder = false,
        side = "left",
        width = 30,
        signcolumn = "yes",
        mappings = {
            custom_only = true,
            list = {
                { key = "<ESC>",                     action = "close" },
                { key = { "<CR>", "<2-LeftMouse>" }, action = "edit" },
                { key = "<F5>",                      action = "refresh" },
                { key = "a",                         action = "create" },
                { key = "d",                         action = "trash" },  -- move file/folder to trash
                { key = "D",                         action = "remove" }, -- delete permanently
                { key = "r",                         action = "rename" },
                { key = "x",                         action = "cut" },
                { key = "c",                         action = "copy" },
                { key = "p",                         action = "paste" },
                { key = "y",                         action = "copy_name" },
                { key = "Y",                         action = "copy_absolute_path" },
                { key = "<S-Tab>",                   action = "collapse_all" },
                { key = "<Tab>",                     action = "expand_all" },
                { key = "K",                         action = "toggle_file_info" },
            },
        },
    },
    actions = {
        change_dir = {
            enable = true,
            restrict_above_cwd = true,
        },
        file_popup = {
            open_win_config = {
                col = 1,
                row = 1,
                relative = "cursor",
                border = "none",
                style = "minimal",
            },
        },
    },
    renderer = {
        group_empty = true,
        highlight_git = true,
        highlight_modified = "all",
        root_folder_modifier = table.concat({ ":t:gs?$?", string.rep(" ", 1000), "?:gs?^??" }),
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
        icons = { error = "", warning = "", info = "", hint = "" },
    },
    filters = {
        dotfiles = false,
    }
})

local keymap = require("util").keymap

keymap("n", "<C-e>", ":NvimTreeToggle<CR>")

-- auto change bufferline's offset
local have_bufferline, bufferline_api = pcall(require, "bufferline.api")
if have_bufferline then
    local nvim_tree_events = require("nvim-tree.events")
    local nvim_tree_view = require("nvim-tree.view")

    nvim_tree_events.subscribe("TreeOpen", function()
        bufferline_api.set_offset(nvim_tree_view.View.width)
    end)

    nvim_tree_events.subscribe("Resize", function()
        bufferline_api.set_offset(nvim_tree_view.View.width)
    end)

    nvim_tree_events.subscribe("TreeClose", function()
        bufferline_api.set_offset(0)
    end)
end

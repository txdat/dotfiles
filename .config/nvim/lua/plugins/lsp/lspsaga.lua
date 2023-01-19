require("lspsaga").setup({
    preview = {
        lines_above = 0,
        lines_below = 10,
    },
    scroll_preview = {
        scroll_down = "<C-j>",
        scroll_up = "<C-k>",
    },
    request_timeout = 2000,
    finder = {
        edit = "e",
        vsplit = "v",
        split = "s",
        tabe = "t",
        quit = "<ESC>",
    },
    definition = {
        edit = "e",
        vsplit = "v",
        split = "s",
        tabe = "t",
        quit = "<ESC>",
    },
    code_action = {
        num_shortcut = true,
        keys = {
            exec = "<CR>",
            quit = "<ESC>",
        },
    },
    lightbulb = {
        enable = true,
        enable_in_insert = true,
        sign = true,
        sign_priority = 40,
        virtual_text = true,
    },
    diagnostic = {
        show_code_action = true,
        show_source = true,
        jump_num_shortcut = true,
        keys = {
            exec_action = "<CR>",
            quit = "<ESC>",
            go_action = "g",
        },
    },
    rename = {
        mark = "<Tab>",
        confirm = "<CR>",
        exec = "<CR>",
        quit = "<ESC>",
        in_select = true,
        whole_project = true,
    },
    outline = {
        win_position = "right",
        win_with = "",
        win_width = 50,
        show_detail = true,
        auto_preview = true,
        auto_refresh = true,
        auto_close = true,
        custom_sort = nil,
        keys = {
            jump = "o",
            expand_collaspe = "<CR>",
            quit = "<ESC>",
        },
    },
    callhierarchy = {
        show_detail = false,
        keys = {
            edit = "e",
            vsplit = "v",
            split = "s",
            tabe = "t",
            jump = "o",
            expand_collaspe = "<CR>",
            quit = "<ESC>",
        },
    },
    symbol_in_winbar = {
        enable = true,
        separator = "  ",
        hide_keyword = true,
        show_file = true,
        folder_level = 2,
        respect_root = false,
        color_mode = true,
    },
    ui = {
        theme = "round",
        title = true,
        border = "single",
        winblend = 0,
        expand = "",
        collaspe = "",
        preview = "",
        code_action = "💡",
        diagnostic = "🐞",
        incoming = "",
        outgoing = "",
        colors = {
            normal_bg = "#0f111b", -- spaceduck
            title_bg = "#7a5ccc",
            red = "#c34043", -- kanagawa
            magenta = "#d27e99",
            orange = "#ffa066",
            yellow = "#dca561",
            green = "#76946a",
            cyan = "#6a9589",
            blue = "#7e9cd8",
            purple = "#957fb8",
            white = "#ecf0c1",
            black = "#0f111b",
            -- black = "#161616", -- oxocarbon
        },
        kind = {},
    },
})

vim.wo.winbar = require("lspsaga.symbolwinbar"):get_winbar()
--vim.wo.stl = require("lspsaga.symbolwinbar"):get_winbar()

local keymap = require("util").keymap

keymap("n", "<leader>lf", ":Lspsaga lsp_finder<CR>")
keymap("n", "<leader>pd", ":Lspsaga peek_definition<CR>")
keymap("n", "<leader>od", ":Lspsaga goto_definition<CR>")
keymap("n", "<leader>so", ":Lspsaga outline<CR>")
keymap("n", "<leader>rn", ":Lspsaga rename<CR>")
keymap("n", "<leader>ca", ":Lspsaga code_action<CR>")
keymap("n", "K", ":Lspsaga hover_doc<CR>")
keymap("n", "<A-k>", ":Lspsaga hover_doc ++keep<CR>")

-- diagnostic
keymap("n", "<leader>dl", ":Lspsaga show_line_diagnostics<CR>")
keymap("n", "<leader>dc", ":Lspsaga show_cursor_diagnostics<CR>")
keymap("n", "<leader>db", ":Lspsaga show_buf_diagnostics<CR>")
keymap("n", "d[", ":Lspsaga diagnostic_jump_prev<CR>")
keymap("n", "d]", ":Lspsaga diagnostic_jump_next<CR>")
keymap("n", "e[", function()
    require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)
keymap("n", "e]", function()
    require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end)

-- callhierarchy
keymap("n", "<leader>ic", ":Lspsaga incoming_calls<CR>")
keymap("n", "<leader>oc", ":Lspsaga outgoing_calls<CR>")

-- float terminal
keymap({ "n", "t" }, "<A-t>", "<cmd>Lspsaga term_toggle<CR>")

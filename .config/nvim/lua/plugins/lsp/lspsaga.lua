require("lspsaga").setup({
    scroll_preview = {
        scroll_down = "<C-j>",
        scroll_up = "<C-k>",
    },
    finder = {
        keys = {
            jump_to = "<CR>",
            edit = "e",
            vsplit = "v",
            split = "s",
            tabe = "t",
            quit = "<ESC>",
            close_in_preview = "<ESC>",
        },
    },
    definition = {
        edit = "e",
        vsplit = "v",
        split = "s",
        tabe = "t",
        quit = "<ESC>",
        close = "<ESC>",
    },
    code_action = {
        keys = {
            exec = "<CR>",
            quit = "<ESC>",
        },
    },
    lightbulb = {
        enable = true,
        enable_in_insert = false,
        sign = false,
        virtual_text = true,
    },
    diagnostic = {
        custom_fix = "Action",
        custom_msg = "Diagnostic",
        keys = {
            exec_action = "<CR>",
            quit = "<ESC>",
            go_action = "<Tab>",
        },
    },
    rename = {
        mark = "<Tab>",
        confirm = "<CR>",
        exec = "<CR>",
        quit = "<ESC>",
    },
    outline = {
        win_width = 50,
        keys = {
            jump = "<CR>",
            expand_collaspe = "<Tab>",
            quit = "<ESC>",
        },
    },
    callhierarchy = {
        keys = {
            edit = "e",
            vsplit = "v",
            split = "s",
            tabe = "t",
            jump = "<CR>",
            expand_collaspe = "<Tab>",
            quit = "<ESC>",
        },
    },
    symbol_in_winbar = {
        enable = true,
        separator = "  ",
    },
    beacon = {
        enable = false,
    },
    ui = {
        theme = "round",
        title = true,
        border = "single",
        code_action = "ﯦ",
        diagnostic = "",
    },
})

vim.wo.winbar = require("lspsaga.symbolwinbar"):get_winbar()
--vim.wo.stl = require("lspsaga.symbolwinbar"):get_winbar()

-- disable shadow
vim.api.nvim_set_hl(0, "SagaShadow", { bg = "NONE" })

local keymap = require("util").keymap

keymap("n", "<leader>lf", ":Lspsaga lsp_finder<CR>")
keymap("n", "<leader>pd", ":Lspsaga peek_definition<CR>")
keymap("n", "<leader>gd", ":Lspsaga goto_definition<CR>")
keymap("n", "<leader>so", ":Lspsaga outline<CR>")
keymap("n", "<leader>ca", ":Lspsaga code_action<CR>")
keymap("n", "<leader>rn", ":Lspsaga rename<CR>")
keymap("n", "<leader>rnp", ":Lspsaga rename ++project<CR>")
keymap("n", "K", ":Lspsaga hover_doc<CR>")
keymap("n", "Kk", ":Lspsaga hover_doc ++keep<CR>")

-- diagnostic
keymap("n", "<leader>dl", ":Lspsaga show_line_diagnostics<CR>")
keymap("n", "<leader>dc", ":Lspsaga show_cursor_diagnostics<CR>")
keymap("n", "<leader>db", ":Lspsaga show_buf_diagnostics<CR>")
keymap("n", "d[", ":Lspsaga diagnostic_jump_prev<CR>")
keymap("n", "d]", ":Lspsaga diagnostic_jump_next<CR>")
keymap("n", "D[", function()
    require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)
keymap("n", "D]", function()
    require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
end)

-- callhierarchy
keymap("n", "<leader>ic", ":Lspsaga incoming_calls<CR>")
keymap("n", "<leader>oc", ":Lspsaga outgoing_calls<CR>")

-- float terminal
keymap({ "n", "t" }, "<leader>t", "<cmd>Lspsaga term_toggle<CR>")

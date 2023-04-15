require("lspsaga").setup({
    scroll_preview = {
        scroll_down = "<C-j>",
        scroll_up = "<C-k>",
    },
    finder = {
        keys = {
            jump_to = "<CR>",
            expand_or_jump = "<Tab>",
            vsplit = "v",
            split = "s",
            tabe = "t",
            tabnew = "n",
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
    },
    code_action = {
        keys = {
            exec = "<CR>",
            quit = "<ESC>",
        },
    },
    lightbulb = {
        sign = false,
        virtual_text = true,
    },
    hover = {
        open_link = '<CR>',
        open_browser = '!firefox',
    },
    diagnostic = {
        on_insert = false, -- use default lsp
        on_insert_follow = false,
        insert_winblend = 0,
        keys = {
            exec_action = "<CR>",
            quit = "<ESC>",
            go_action = "<Tab>",
            expand_or_jump = "<CR>",
            quit_in_show = "<ESC>",
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
            expand_or_jump = "<CR>",
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
            expand_collapse = "<Tab>",
            quit = "<ESC>",
        },
    },
    symbol_in_winbar = {
        enable = true,
        separator = "  ",
        ignore_patterns = { "%w_spec" },
    },
    beacon = {
        enable = false,
    },
    ui = {
        title = false,
        border = "none",
        winblend = 0,
        code_action = "",
    },
})

vim.wo.winbar = require("lspsaga.symbolwinbar"):get_winbar()
--vim.wo.stl = require("lspsaga.symbolwinbar"):get_winbar()

-- disable shadow
vim.api.nvim_set_hl(0, "SagaShadow", { bg = "NONE" })

local keymap = require("util").keymap

keymap("n", "gh", ":Lspsaga lsp_finder<CR>")
keymap("n", "gd", ":Lspsaga peek_definition<CR>")
keymap("n", "gD", ":Lspsaga goto_definition<CR>")
keymap("n", "gt", ":Lspsaga peek_type_definition<CR>")
keymap("n", "gT", ":Lspsaga goto_type_definition<CR>")
keymap("n", "<leader>o", ":Lspsaga outline<CR>")
keymap("n", "<leader>ca", ":Lspsaga code_action<CR>")
keymap("n", "gr", ":Lspsaga rename<CR>")
keymap("n", "gR", ":Lspsaga rename ++project<CR>")
keymap("n", "K", ":Lspsaga hover_doc<CR>")
keymap("n", "Kk", ":Lspsaga hover_doc ++keep<CR>")

-- diagnostic
keymap("n", "<leader>dc", ":Lspsaga show_cursor_diagnostics<CR>")
keymap("n", "<leader>dl", ":Lspsaga show_line_diagnostics<CR>")
keymap("n", "<leader>db", ":Lspsaga show_buf_diagnostics<CR>")
keymap("n", "<leader>dw", ":Lspsaga show_workspace_diagnostics<CR>")
keymap("n", "[d", ":Lspsaga diagnostic_jump_prev<CR>")
keymap("n", "]d", ":Lspsaga diagnostic_jump_next<CR>")
keymap("n", "[D", function()
    require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)
keymap("n", "]D", function()
    require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
end)

-- callhierarchy
keymap("n", "<leader>gci", ":Lspsaga incoming_calls<CR>")
keymap("n", "<leader>gco", ":Lspsaga outgoing_calls<CR>")

-- float terminal
keymap({ "n", "t" }, "<C-S-t>", "<cmd>Lspsaga term_toggle<CR>")

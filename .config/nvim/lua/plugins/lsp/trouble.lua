require("trouble").setup({
    position = "bottom",
    height = 30,
    mode = "workspace_diagnostics",
    severity = vim.diagnostic.severity.WARN, -- >= WARN only
    signs = {
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "󰝥",
    },
    use_diagnostic_signs = true,
    action_keys = {
        close = {},
        cancel = "<ESC>",
        refresh = "r",
        jump = "<CR>",
        open_split = "x",
        open_vsplit = "v",
        open_tab = "t",
        jump_close = "o",
        toggle_mode = "<Tab>",
        switch_severity = "s",
        toggle_preview = "<C-p>",
        preview = "p",
        hover = "K",
        close_folds = "zm",
        open_folds = "zr",
        toggle_folds = "za",
        previous = "k",
        next = "j",
    },
})

local keymap = require("util").keymap

keymap("n", "<leader>tt", ":TroubleToggle<CR>")
keymap("n", "<leader>tw", ":TroubleToggle workspace_diagnostics<CR>")
keymap("n", "<leader>td", ":TroubleToggle document_diagnostics<CR>")
keymap("n", "<leader>tq", ":TroubleToggle quickfix<CR>")
keymap("n", "<leader>tl", ":TroubleToggle loclist<CR>")

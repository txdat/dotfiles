require("gitsigns").setup({
    signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
    },
    preview_config = {
        border = "none"
    },
    sign_priority = 15,
})

local keymap = require("util").keymap

keymap("n", "[h", ":Gitsigns prev_hunk<CR>")
keymap("n", "]h", ":Gitsigns next_hunk<CR>")
keymap("n", "<leader>gs", ":Gitsigns stage_hunk<CR>")
keymap("v", "<leader>gs", ":'<,'>Gitsigns stage_hunk<CR>")
keymap("n", "<leader>gr", ":Gitsigns reset_hunk<CR>")
keymap("v", "<leader>gr", ":'<,'>Gitsigns reset_hunk<CR>")
keymap("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>")
keymap("n", "<leader>gsb", ":Gitsigns stage_buffer<CR>")
keymap("n", "<leader>grb", ":Gitsigns reset_buffer<CR>")
keymap("n", "<leader>gb", ":Gitsigns blame_line<CR>")
keymap("n", "<leader>gp", ":Gitsigns preview_hunk_inline<CR>")
keymap("n", "<leader>gd", ":Gitsigns diffthis<CR>")
-- keymap({ "o", "x" }, "<leader>gh", ":Gitsigns select_hunk<CR>")

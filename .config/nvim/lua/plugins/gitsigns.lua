require("gitsigns").setup()

local keymap = require("util").keymap

keymap("n", "h[", ":Gitsigns prev_hunk<CR>")
keymap("n", "h]", ":Gitsigns next_hunk<CR>")

keymap("n", "<leader>hs", ":Gitsigns stage_hunk<CR>")
keymap("n", "<leader>hr", ":Gitsigns reset_hunk<CR>")
keymap("n", "<leader>hu", ":Gitsigns undo_stage_hunk<CR>")
keymap("n", "<leader>hS", ":Gitsigns stage_buffer<CR>")
keymap("n", "<leader>hR", ":Gitsigns reset_buffer<CR>")
keymap("n", "<leader>hb", ":Gitsigns blame_line<CR>")
keymap("n", "<leader>hi", ":Gitsigns preview_hunk_inline<CR>")
keymap("n", "<leader>hd", ":Gitsigns diffthis<CR>")

keymap({ "o", "x" }, "<leader>hx", ":Gitsigns select_hunk<CR>")

local highlight = vim.api.nvim_set_hl

-- use default highlights
highlight(0, "GitConflictDiffAdd", {})
highlight(0, "GitConflictDiffText", {})

require("git-conflict").setup({
    default_mappings = false,
    highlights = {
        incoming = "GitConflictDiffAdd",
        current = "GitConflictDiffText",
    },
})

local keymap = require("util").keymap

keymap("n", "H[", ":GitConflictPrevConflict<CR>")
keymap("n", "H]", ":GitConflictNextConflict<CR>")

keymap("n", "<leader>hc", ":GitConflictListQf<CR>")
keymap("n", "<leader>ho", ":GitConflictChooseOurs<CR>")
keymap("n", "<leader>ht", ":GitConflictChooseTheirs<CR>")
keymap("n", "<leader>h0", ":GitConflictChooseNone<CR>")
keymap("n", "<leader>h1", ":GitConflictChooseBoth<CR>")

require("bufferline").setup {
    animation = false,
    auto_hide = false,
    tabpages = false,
    exclude_ft = {},
    hide = {
        extensions = false,
        inactive = false,
    },
    icons = {
        diagnostics = {
            [vim.diagnostic.severity.ERROR] = { enabled = false },
            [vim.diagnostic.severity.WARN] = { enabled = false },
            [vim.diagnostic.severity.INFO] = { enabled = false },
            [vim.diagnostic.severity.HINT] = { enabled = false },
        },
        gitsigns = {
            added = { enabled = false, icon = " " },
            changed = { enabled = false, icon = " " },
            deleted = { enabled = false, icon = " " },
        },
    },
}

-- vim.cmd([[highlight BufferTabpageFill guibg=#080808]])

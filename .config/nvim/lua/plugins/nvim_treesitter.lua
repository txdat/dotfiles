require("nvim-treesitter.configs").setup {
    ensure_installed = {
        "lua",
        "c", "cpp", "cmake", "llvm", "cuda",
        "rust",
        "go",
        "python",
        "haskell",
        "javascript", "typescript",
        "markdown", "markdown_inline",
        "latex",
    },
    sync_install = false,
    auto_install = false,
    ignore_install = {},
    autopairs = {
        enable = true,
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<S-CR>",
            node_decremental = "<BS>",
        },
    },
    indent = {
        enable = true,
    }
}

vim.api.nvim_set_hl(0, "@punctuation.bracket", { link = "" })

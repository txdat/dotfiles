require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "markdown", "c", "cpp", "cmake", "python", "rust", "go" },
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
        enable = true
    },
    indent = {
        enable = true,
    }
}

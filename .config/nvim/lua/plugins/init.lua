local plugins_cfg = {
    "impatient",
    "packer",
    "colorscheme",
    "lualine",
    "bufferline",
    "indent_blankline",
    "nvim_treesitter",
    "comment",
    "nvim_autopairs",
    "hop",
    "nvim_tree",
    "telescope",
    "bqf",
    "gitsigns",
    -- "vimtex",
    "lsp",
    -- "dap",
}

for _, cfg in ipairs(plugins_cfg) do
    pcall(require, "plugins." .. cfg)
end

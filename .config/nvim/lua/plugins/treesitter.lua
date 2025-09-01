local ensure_installed = {
    "c",
    "cmake",
    "cpp",
    -- "cuda",
    "dockerfile",
    -- "go",
    -- "haskell",
    -- "hcl",
    "javascript",
    "json",
    -- "latex",
    -- "llvm",
    -- "lua",
    "markdown",
    "markdown_inline",
    "proto",
    "python",
    -- "rust",
    -- "terraform",
    "typescript",
    -- "vim",
    "yaml",
}

vim.defer_fn(function() require("nvim-treesitter").install(ensure_installed) end, 1000)
require("nvim-treesitter").update()

-- auto-start highlights & indentation
vim.api.nvim_create_autocmd("FileType", {
    desc = "User: enable treesitter highlighting",
    callback = function(ctx)
        -- highlights
        local has_started = pcall(vim.treesitter.start) -- errors for filetypes with no parser

        if has_started then
          -- indent
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

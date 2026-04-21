local ensure_installed = {
    "c",
    "cpp",
    "go",
    "javascript",
    "proto",
    "python",
    "rust",
    "typescript",
}

vim.defer_fn(function() require("nvim-treesitter").install(ensure_installed) end, 1000)
-- require("nvim-treesitter").update()

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

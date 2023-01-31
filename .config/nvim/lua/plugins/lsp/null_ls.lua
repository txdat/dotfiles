local null_ls = require("null-ls")
local fmt = null_ls.builtins.formatting

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
    debug = false,
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format { bufnr = bufnr, async = true }
                end,
            })
        end
    end,
    sources = {
        -- fmt.clang_format, -- c/c++
        fmt.rustfmt.with({ -- rust
            extra_args = { "--edition=2021" }
        }),
        fmt.black, -- python
        fmt.prettier, -- js,ts,...
        fmt.sqlfluff.with({ -- sql
            extra_args = { "--dialect", "postgres" }, -- change to your dialect
        }),
    },
})

local keymap = require("util").keymap

keymap("n", "<leader>bf", function()
    vim.lsp.buf.format { async = true }
end)

local null_ls = require ('null-ls')

null_ls.setup({
    on_init = function(client, _)
        client.offset_encoding = 'utf-8' -- conflict with lsp
    end,
    sources = {
        null_ls.builtins.diagnostics.clang_check, -- c/c++
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.diagnostics.ruff, -- python
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.rustfmt, -- rust
    },
})

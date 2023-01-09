local M = {}

-- mason only
M.ensure_installed = {
    'lua-language-server',  -- sumneko_lua
}

M.servers = {
    'sumneko_lua',          -- lua
    'clangd',               -- c/c++
    'pyright',              -- python
    'rust_analyzer',        -- rust
    'gopls',                -- go
    'hls',                  -- haskell
    'eslint',               -- javascript/typescript
    'tsserver',             -- typescript
    'texlab',               -- latex
}

return M

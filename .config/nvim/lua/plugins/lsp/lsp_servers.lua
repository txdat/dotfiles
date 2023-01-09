local M = {}

M.ensure_installed = {}

M.servers = {
    'clangd',               -- c/c++
    'pyright',              -- python
    'rust_analyzer',        -- rust
    'gopls',                -- go
    'hls',                  -- haskell
    'eslint',               -- javascript/typescript
    'tsserver',             -- typescript
    'texlab',               -- latex
    'sumneko_lua',          -- lua
}

return M

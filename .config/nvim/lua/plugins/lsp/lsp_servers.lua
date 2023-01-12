local M = {}

M.ensure_installed = {
    'sumneko_lua', -- lua
}

M.servers = {
    'sumneko_lua', -- lua
    'clangd', -- c/c++
    'pyright', -- python
    'rust_analyzer', -- rust
    'gopls', -- go
    'hls', -- haskell
    'eslint', -- javascript/typescript
    'tsserver', -- typescript
    'texlab', -- latex
}

return M

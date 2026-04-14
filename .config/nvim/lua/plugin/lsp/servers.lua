local M = {}

M.clangd = {
  cmd = {
    "clangd",
    "-log=error",
    "--limit-results=500",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm"
  },
}

-- M.rust_analyzer = {
-- }

-- M.gopls = {
-- }

M.pyright = {
}

-- typescript-language-server
-- M.ts_ls = {
-- }

-- vtsls
M.vtsls = {
}

-- vscode-langservers-extracted
M.eslint = {
}

return M

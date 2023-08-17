local M = {}

M.lua_ls = {
    settings = {
        Lua = {
            diagnostics = {
                enable = true,
                globals = { "vim" },
            },
            runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
            },
            workspace = {
                library = (function()
                    local lib = {}
                    for _, path in ipairs(vim.api.nvim_get_runtime_file("lua", true)) do
                        lib[#lib + 1] = path:sub(1, -5)
                    end
                    return lib
                end)(),
                checkThirdParty = false,
            },
            -- hint = { enable = true },
            telemetry = {
                enable = false,
            },
        },
    },
}

M.clangd = {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--suggest-missing-includes",
        "--completion-style=bundled",
        "--cross-file-rename",
        "--header-insertion=iwyu",
    },
    settings = {
        clangd = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true
        },
    },
}

M.rust_analyzer = {
    cmd = { "rustup", "run", "stable", "rust-analyzer" },
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                allFeatures = true,
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
            },
            checkOnSave = true,
            check = {
                command = "clippy",
                extraArgs = { "--no-deps" },
            },
        },
    },
}

M.gopls = {
    cmd = { "gopls", "serve" },
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            staticcheck = true,
            analyses = {
                unusedparams = true,
            },
            -- hints = {
            --     assignVariableTypes = true,
            --     compositeLiteralFields = true,
            --     compositeLiteralTypes = true,
            --     constantValues = true,
            --     functionTypeParameters = true,
            --     parameterNames = true,
            --     rangeVariableTypes = true,
            -- },
        },
    },
}

M.pyright = {
    settings = {
        pyright = {
            autoImportCompletion = true,
        },
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "off"
            }
        }
    },
}

-- M.hls = {
--     filetypes = { "haskell", "lhaskell", "cabal", "cabalproject" },
--     settings = {
--         haskell = {
--             formattingProvider = "fourmolu",
--             cabalFormattingProvider = "cabalfmt",
--             maxCompletions = 40,
--             checkProject = true,
--             checkParents = "CheckOnSave",
--         },
--     },
-- }

-- -- typescript-language-server
-- M.tsserver = {
--     filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
-- }

-- vscode-langservers-extracted
M.eslint = {
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
}

M.texlab = {}

return M

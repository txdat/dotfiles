local M = {}

M.lua_ls = {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            runtime = {
                version = "LuaJIT",
                -- path = vim.split(package.path, ";"),
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                }
            },
            completion = {
                callSnippet = "Replace",
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
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
    },
    settings = {
        init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true
        },
    },
}

-- M.rust_analyzer = {
--     settings = {
--         ["rust-analyzer"] = {
--             imports = {
--                 granularity = {
--                     group = "module",
--                 },
--                 prefix = "self",
--             },
--             cargo = {
--                 allFeatures = true,
--                 loadOutDirsFromCheck = true,
--                 runBuildScripts = true,
--             },
--             -- Add clippy lints for Rust.
--             checkOnSave = {
--                 allFeatures = true,
--                 command = "clippy",
--                 extraArgs = { "--no-deps" },
--             },
--             procMacro = {
--                 enable = true,
--                 ignored = {
--                     ["async-trait"] = { "async_trait" },
--                     ["napi-derive"] = { "napi" },
--                     ["async-recursion"] = { "async_recursion" },
--                 },
--             },
--         },
--     },
-- }

-- M.gopls = {
--     init_options = {
--         usePlaceholders = true,
--         completeUnimported = true,
--     },
--     settings = {
--         gopls = {
--             analyses = {
--                 unusedparams = true,
--             },
--             -- semanticTokens = true,
--             staticcheck = true,
--             gofumpt = true,
--         },
--     },
-- }

M.pyright = {}

-- M.hls = {}

-- typescript-language-server
M.tsserver = {
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    settings = {
        completions = {
            completeFunctionCalls = false,
        },
    },
}

-- vscode-langservers-extracted
M.eslint = {
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    settings = {
        workingDirectories = { mode = "auto" },
        experimental = {
            useFlatConfig = false,
        }
    }
}

-- M.texlab = {}

return M

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
        "--suggest-missing-includes",
        "--clang-tidy",
        "--header-insertion=iwyu",
    },
}

M.rust_analyzer = {
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
            },
        },
    },
}

M.gopls = {
    cmd = { "gopls", "serve" },
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
    },
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
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

M.hls = {
    filetypes = { "haskell", "lhaskell", "cabal", "cabalproject" },
    settings = {
        haskell = {
            formattingProvider = "fourmolu",
            cabalFormattingProvider = "cabalfmt",
            maxCompletions = 40,
            checkProject = true,
            checkParents = "CheckOnSave",
        },
    },
}

M.tsserver = {}

M.eslint = {
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
}

-- M.texlab = {}

return M

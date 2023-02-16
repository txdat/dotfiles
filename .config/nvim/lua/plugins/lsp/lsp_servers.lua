local M = {}

-- installed by mason automatically
M.ensure_installed = {
    "lua_ls",
}

-- lsp servers with custom config
M.servers_config = {
    lua_ls = {
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
    },
    clangd = {
        cmd = {
            "clangd",
            "--background-index",
            "--suggest-missing-includes",
            "--clang-tidy",
            "--header-insertion=iwyu",
        },
    },
    rust_analyzer = {
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
    },
    gopls = {
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
    },
    pyright = {
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
        single_file_support = true,
    },
    texlab = {},
}

return M

local dap_components = {
    "dapui_watches",
    "dapui_breakpoints",
    "dapui_scopes",
    "dapui_console",
    "dapui_stacks",
    "dap-repl",
}

require("lualine").setup {
    options = {
        theme = "auto",
        -- section_separators = { left = "", right = "" },
        section_separators = "",
        component_separators = "",
        globalstatus = true,
        disabled_filetypes = dap_components,
        ignore_focus = dap_components,
    },
    sections = {
        lualine_a = {
            -- { "fileformat", symbols = { unix = "" } },
            "mode",
        },
        lualine_b = {
            {
                "diagnostics",
                sources = { "nvim_workspace_diagnostic", "nvim_diagnostic", "nvim_lsp" },
                symbols = { error = " ", warn = " ", info = " ", hint = " " },
                update_in_insert = true,
            },
        },
        lualine_c = {},
        lualine_x = {
            {
                "diff",
                symbols = { added = " ", modified = " ", removed = " " },
            },
            {
                "branch",
                icon = "",
            },
        },
        lualine_y = { "location", "progress" },
        lualine_z = {
            {
                "filename",
                file_status = true,
                symbols = {
                    modified = "",
                    readonly = "",
                    unnamed = "[No Name]",
                    newfile = "[New]",
                }
            }
        },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
}

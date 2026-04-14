-- bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end

vim.opt.runtimepath:prepend(lazypath)

local plugins = {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            require("plugin.treesitter")
        end
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("plugin.autopairs")
        end
    },
    {
        "ibhagwan/fzf-lua",
        dependencies = {
        },
        keys = {
            "<leader>ff",
            "<leader>fg",
            "<leader>fs",
        },
        config = function()
            require("plugin.fzf")
        end
    },
    {
        "stevearc/conform.nvim",
        event = "BufRead",
        config = function()
            require("plugin.conform")
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "windwp/nvim-autopairs",
        },
        event = "InsertEnter",
        config = function()
            require("plugin.cmp")
        end,
    },
    -- {
    --     "mfussenegger/nvim-dap",
    --     -- dependencies = {
    --     --     "rcarriga/nvim-dap-ui",
    --     --     "theHamsta/nvim-dap-virtual-text",
    --     -- },
    --     keys = { "<F9>" },
    --     config = function()
    --         require("plugin.dap")
    --         -- require("plugin.dap.ui")
    --         -- require("plugin.dap.virtual_text")
    --     end,
    -- },
}

require("lazy").setup(plugins, {
    defaults = {
        lazy = true,
    },
    install = {
    },
    ui = {
        size = { width = 1, height = 1 },
        border = "none",
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "2html_plugin",
                "bugreport",
                "compiler",
                "ftplugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "man",
                "matchit",
                "matchparen",
                "netrw",
                "netrwFileHandlers",
                "netrwPlugin",
                "netrwSettings",
                "osc52",
                "optwin",
                "rplugin",
                "rrhelper",
                "shada",
                "spellfile",
                "spellfile_plugin",
                "synmenu",
                "tar",
                "tarPlugin",
                "tohtml",
                "tutor",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
            },
        },
    },
    readme = {
        enable = false,
    },
})

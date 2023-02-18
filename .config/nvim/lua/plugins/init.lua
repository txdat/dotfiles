-- bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.runtimepath:prepend(lazypath)

-- config
local plugins = {
    ------------------------------------
    -- gui, navigation
    ------------------------------------

    -- colorscheme
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        config = function()
            pcall(require, "plugins.colorscheme.kanagawa")
        end
    },

    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        config = function()
            pcall(require, "plugins.lualine")
        end,
    },

    -- bufferline
    {
        "romgrk/barbar.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        config = function()
            pcall(require, "plugins.bufferline")
        end,
    },

    -- indent
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufRead",
        config = function()
            pcall(require, "plugins.indent_blankline")
        end
    },

    -- syntax
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufRead",
        config = function()
            pcall(require, "plugins.nvim_treesitter")
        end
    },

    -- commenting
    {
        "numToStr/Comment.nvim",
        event = "InsertEnter",
        config = function()
            pcall(require, "plugins.comment")
        end
    },

    -- auto close brackets
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            pcall(require, "plugins.nvim_autopairs")
        end
    },

    -- navigation
    {
        "phaazon/hop.nvim",
        event = "BufRead",
        config = function()
            pcall(require, "plugins.hop")
        end
    },

    ------------------------------------
    -- file manager, finder, svc
    ------------------------------------

    -- file manager
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        keys = { "<C-e>" },
        config = function()
            pcall(require, "plugins.nvim_tree")
        end
    },

    -- finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            -- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-telescope/telescope-fzy-native.nvim",
            {
                "kevinhwang91/nvim-bqf",
                config = function()
                    pcall(require, "plugins.bqf")
                end
            },
        },
        keys = {
            "<leader>ff",
            "<leader>fg",
            "<leader>fb",
            "<leader>fs",
        },
        config = function()
            pcall(require, "plugins.telescope")
        end
    },

    -- svc
    {
        "lewis6991/gitsigns.nvim",
        event = "BufRead",
        config = function()
            pcall(require, "plugins.gitsigns")
        end
    },

    ------------------------------------
    -- autocompletion, debugging
    ------------------------------------

    -- autocompletion, diagnostics, formatting
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            -- "hrsh7th/cmp-nvim-lsp-signature-help",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            { "glepnir/lspsaga.nvim",
                branch = "main",
                dependencies = {
                    "nvim-tree/nvim-web-devicons",
                    "nvim-treesitter/nvim-treesitter"
                }
            },
            "jose-elias-alvarez/null-ls.nvim",
        },
        event = "InsertEnter",
        config = function()
            pcall(require, "plugins.lsp")
        end,
    },

    -- debugging
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
        },
        keys = { "<F5>", "<F9>" }, -- triggered when start debugging
        config = function()
            pcall(require, "plugins.dap")
        end,
    },

    ------------------------------------
    -- prog. langs
    ------------------------------------

    -- markdown
    {
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        ft = { "markdown" }, -- triggered when opening *.md file
        config = function()
            pcall(require, "plugins.markdown_preview")
        end
    },

    -- latex
    {
        "lervag/vimtex",
        ft = { "tex" }, -- triggered when opening *.tex file
        config = function()
            pcall(require, "plugins.vimtex")
        end
    },
}

local opts = {
    defaults = {
        lazy = true,
    },
    lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json",
    dev = {
        path = "~/workspace", -- local plugins directory
    },
    git = {
        timeout = 300, -- seconds
    },
    install = {
        colorscheme = { "kanagawa" },
    },
    ui = {
        border = "single",
    },
}

require("lazy").setup(plugins, opts)

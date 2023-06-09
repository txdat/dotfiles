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

-- config
local plugins = {
    ------------------------------------
    -- gui, navigation
    ------------------------------------

    -- colorscheme
    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         pcall(require, "plugins.colorscheme.tokyonight")
    --     end
    -- },
    {
        "bluz71/vim-moonfly-colors",
        lazy = false,
        priority = 1000,
        config = function()
            pcall(require, "plugins.colorscheme.moonfly");
        end
    },
    -- {
    --     "projekt0n/github-nvim-theme",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         pcall(require, "plugins.colorscheme.github");
    --     end
    -- },

    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        config = function()
            pcall(require, "plugins.evil_lualine")
        end,
    },

    -- bufferline
    -- {
    --     "romgrk/barbar.nvim",
    --     dependencies = {
    --         "nvim-tree/nvim-web-devicons",
    --     },
    --     event = "BufRead",
    --     config = function()
    --         pcall(require, "plugins.bufferline")
    --     end,
    -- },

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
        dependencies = {
            -- "nvim-treesitter/nvim-treesitter-textobjects",
        },
        build = ":TSUpdate",
        event = "BufRead",
        config = function()
            pcall(require, "plugins.treesitter")
        end
    },

    -- colorizer
    -- {
    --     "NvChad/nvim-colorizer.lua",
    --     event = "BufRead",
    --     config = function()
    --         pcall(require, "plugins.colorizer")
    --     end
    -- },

    -- commenting
    {
        "numToStr/Comment.nvim",
        event = "InsertEnter",
        config = function()
            pcall(require, "plugins.comment")
        end
    },

    -- auto close brackets, tags
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            pcall(require, "plugins.autopairs")
        end
    },
    -- html's tags
    -- {
    --     "windwp/nvim-ts-autotag",
    --     event = "InsertEnter",
    --     config = function()
    --         pcall(require, "plugins.ts_autotag")
    --     end
    -- },

    -- surround selections
    {
        "kylechui/nvim-surround",
        event = "InsertEnter",
        config = function()
            pcall(require, "plugins.surround")
        end,
    },

    -- navigation
    -- {
    --     "phaazon/hop.nvim",
    --     event = "BufRead",
    --     config = function()
    --         pcall(require, "plugins.hop")
    --     end
    -- },

    ------------------------------------
    -- file manager, finder, svc
    ------------------------------------

    -- file manager
    -- {
    --     "nvim-tree/nvim-tree.lua",
    --     dependencies = {
    --         "nvim-tree/nvim-web-devicons",
    --     },
    --     keys = { "<C-e>" },
    --     config = function()
    --         pcall(require, "plugins.tree")
    --     end
    -- },

    -- fuzzy finder
    -- {
    --     "nvim-telescope/telescope.nvim",
    --     dependencies = {
    --         "nvim-telescope/telescope-file-browser.nvim",
    --         "nvim-telescope/telescope-ui-select.nvim",
    --         "nvim-telescope/telescope-live-grep-args.nvim",
    --         -- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    --         "nvim-telescope/telescope-fzy-native.nvim",
    --         "nvim-lua/plenary.nvim",
    --         {
    --             "kevinhwang91/nvim-bqf",
    --             config = function()
    --                 pcall(require, "plugins.bqf")
    --             end
    --         },
    --     },
    --     keys = {
    --         "<C-e>",
    --         "<leader>ff",
    --         "<leader>fg",
    --     },
    --     config = function()
    --         pcall(require, "plugins.telescope")
    --     end
    -- },
    {
        "ibhagwan/fzf-lua",
        dependencies = {
            -- {
            --     "junegunn/fzf",
            --     build = "./install --bin",
            -- },
            "nvim-tree/nvim-web-devicons",
            {
                "kevinhwang91/nvim-bqf",
                config = function()
                    pcall(require, "plugins.bqf")
                end
            },
        },
        -- keys = {},
        config = function()
            pcall(require, "plugins.fzf")
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

    -- diagnostics, formatting
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- {
            --     "williamboman/mason.nvim",
            --     dependencies = {
            --         "williamboman/mason-lspconfig.nvim",
            --     },
            -- },
            -- {
            --     "glepnir/lspsaga.nvim",
            --     branch = "main",
            --     dependencies = {
            --         "nvim-tree/nvim-web-devicons",
            --         "nvim-treesitter/nvim-treesitter"
            --     }
            -- },
            -- "jose-elias-alvarez/null-ls.nvim",
            -- {
            --     "folke/trouble.nvim",
            --     dependencies = {
            --         "nvim-tree/nvim-web-devicons",
            --     },
            -- },
        },
        event = "BufRead",
        config = function()
            pcall(require, "plugins.lsp")
        end,
    },

    -- autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            -- "hrsh7th/cmp-nvim-lsp-signature-help",
            "saadparwaiz1/cmp_luasnip",
            {
                "L3MON4D3/LuaSnip",
                dependencies = {
                    "rafamadriz/friendly-snippets",
                },
            },
        },
        event = "InsertEnter",
        config = function()
            pcall(require, "plugins.lsp.cmp")
        end,
    },

    -- debugging
    -- {
    --     "mfussenegger/nvim-dap",
    --     dependencies = {
    --         "rcarriga/nvim-dap-ui",
    --         "theHamsta/nvim-dap-virtual-text",
    --     },
    --     keys = { "<F5>", "<F9>" }, -- triggered when start debugging
    --     config = function()
    --         pcall(require, "plugins.dap")
    --     end,
    -- },

    ------------------------------------
    -- prog. langs
    ------------------------------------

    -- -- scala
    -- {
    --     "scalameta/nvim-metals",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --     },
    --     ft = { "scala" },
    --     config = function()
    --         pcall(require, "plugins.lsp.cmp.scala_metals")
    --     end,
    -- },

    -- -- orgmode
    -- {
    --     "nvim-neorg/neorg",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-treesitter/nvim-treesitter",
    --     },
    --     build = ":Neorg sync-parsers",
    --     ft = { "norg" }, -- triggered when opening *.norg file
    --     config = function()
    --         pcall(require, "plugins.neorg")
    --     end
    -- },

    -- -- markdown
    -- {
    --     "iamcco/markdown-preview.nvim",
    --     build = function()
    --         vim.fn["mkdp#util#install"]()
    --     end,
    --     ft = { "markdown" }, -- triggered when opening *.md file
    --     config = function()
    --         pcall(require, "plugins.markdown_preview")
    --     end
    -- },

    -- -- latex
    -- {
    --     "lervag/vimtex",
    --     ft = { "tex" }, -- triggered when opening *.tex file
    --     config = function()
    --         pcall(require, "plugins.vimtex")
    --     end
    -- },
}

local opts = {
    defaults = {
        lazy = true,
    },
    -- lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json",
    dev = {
        path = "~/workspace", -- local plugins directory
    },
    git = {
        timeout = 300, -- seconds
    },
    install = {
        colorscheme = { "moonfly" },
    },
    ui = {
        border = "none",
    },
}

require("lazy").setup(plugins, opts)

-- custom keymap
local lazy_view_config = require("lazy.view.config")
lazy_view_config.keys.close = "<ESC>"

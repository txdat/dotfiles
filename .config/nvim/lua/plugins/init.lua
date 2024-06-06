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

-- plugins' config
local plugins = {
    ------------------------------------
    -- gui, navigation
    ------------------------------------

    -- colorscheme
    -- {
    --     "bluz71/vim-moonfly-colors",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         pcall(require, "plugins.colorscheme.moonfly");
    --     end
    -- },

    -- statusline
    -- {
    --     "nvim-lualine/lualine.nvim",
    --     dependencies = {
    --         "nvim-tree/nvim-web-devicons",
    --     },
    --     lazy = false,
    --     config = function()
    --         pcall(require, "plugins.lualine")
    --     end,
    -- },

    -- indent
    -- {
    --     "lukas-reineke/indent-blankline.nvim",
    --     event = "BufRead",
    --     config = function()
    --         pcall(require, "plugins.indent_blankline")
    --     end
    -- },

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

    -- commenting
    -- {
    --     "numToStr/Comment.nvim",
    --     dependencies = {
    --         -- "JoosepAlviste/nvim-ts-context-commentstring",
    --     },
    --     event = "InsertEnter",
    --     keys = { { "<A-/>", mode = { "n", "v" } } },
    --     config = function()
    --         pcall(require, "plugins.comment")
    --     end
    -- },

    -- auto close brackets, tags
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            pcall(require, "plugins.autopairs")
        end
    },

    -- surround selections
    -- {
    --     "kylechui/nvim-surround",
    --     event = "InsertEnter",
    --     config = function()
    --         pcall(require, "plugins.surround")
    --     end,
    -- },

    -- navigation
    -- {
    --     "folke/flash.nvim",
    --     event = "BufRead",
    --     config = function()
    --         pcall(require, "plugins.flash")
    --     end
    -- },

    -- quickfix
    {
        "kevinhwang91/nvim-bqf",
        lazy = false,
        config = function()
            pcall(require, "plugins.bqf")
        end
    },


    ------------------------------------
    -- file manager, finder, svc
    ------------------------------------

    -- file manager
    {
        "stevearc/oil.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        keys = { "<C-e>" },
        config = function()
            pcall(require, "plugins.oil")
        end
    },

    -- fuzzy finder
    -- {
    --     "nvim-telescope/telescope.nvim",
    --     dependencies = {
    --         "nvim-telescope/telescope-file-browser.nvim",
    --         "nvim-telescope/telescope-ui-select.nvim",
    --         "nvim-telescope/telescope-live-grep-args.nvim",
    --         { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    --         -- "nvim-telescope/telescope-fzy-native.nvim",
    --         "nvim-lua/plenary.nvim",
    --     },
    --     keys = {
    --         "<C-e>",
    --         "<leader>ff",
    --         "<leader>fg",
    --         "<leader>fh",
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
        },
        keys = {
            "<leader>ff",
            "<leader>fg",
            "<leader>fs",
        },
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

    -- lsp server: diagnostics, formatting
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "stevearc/conform.nvim",
        },
        event = "BufRead",
        config = function()
            pcall(require, "plugins.lsp")
            pcall(require, "plugins.lsp.conform")
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
            -- "saadparwaiz1/cmp_luasnip",
            -- {
            --     "L3MON4D3/LuaSnip",
            --     build = "make install_jsregexp",
            --     dependencies = {
            --         -- "rafamadriz/friendly-snippets",
            --     },
            -- },
        },
        event = "InsertEnter",
        config = function()
            pcall(require, "plugins.lsp.cmp")
        end,
    },

    -- debugging
    -- {
    --     "mfussenegger/nvim-dap",
    --     -- dependencies = {
    --     --     "rcarriga/nvim-dap-ui",
    --     --     "theHamsta/nvim-dap-virtual-text",
    --     -- },
    --     keys = { "<F9>" },
    --     config = function()
    --         pcall(require, "plugins.dap")
    --         -- pcall(require, "plugins.dap.ui")
    --         -- pcall(require, "plugins.dap.virtual_text")
    --     end,
    -- },

    ------------------------------------
    -- prog. langs
    ------------------------------------

    -- typescript
    {
        "pmizio/typescript-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        config = function()
            pcall(require, "plugins.lsp.typescript_tools")
        end
    },

    -- latex
    -- {
    --     "lervag/vimtex",
    --     ft = { "tex" },
    --     config = function()
    --         pcall(require, "plugins.vimtex")
    --     end
    -- },
}

require("lazy").setup(plugins, {
    defaults = {
        lazy = true,
    },
    ui = {
        border = "none",
    },
    readme = {
        enable = false,
    },
})

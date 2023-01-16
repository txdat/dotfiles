local cmd = vim.cmd
local fn = vim.fn

-- automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim",
        install_path })
    vim.o.runtimepath = fn.stdpath("data") .. "/site/pack/*/start/*," .. vim.o.runtimepath
end

-- autocommand that reloads neovim whenever you save the packer.lua file
cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | PackerSync
  augroup end
]]

local packer = require("packer")

packer.init({
    auto_reload_compiled = true,
    display = {
        compact = true,
        open_fn = function()
            return require("packer.util").float({ border = "single" })
        end,
        keybindings = {
            quit = "<ESC>",
        },
    },
    git = {
        clone_timeout = 300 -- seconds
    }
})

return packer.startup(function(use)
    use "wbthomason/packer.nvim" -- packer can manage itself

    -- speed up loading modules
    use "lewis6991/impatient.nvim"

    ------------------------------------
    -- gui, navigation
    ------------------------------------

    -- colorscheme
    use "rebelot/kanagawa.nvim"
    -- use { "pineapplegiant/spaceduck", branch = "main" }
    -- use "nyoom-engineering/oxocarbon.nvim"

    -- status bar
    use {
        "nvim-lualine/lualine.nvim",
        requires = {
            "nvim-tree/nvim-web-devicons",
        }
    }

    -- tabs bar
    use {
        "romgrk/barbar.nvim",
        requires = {
            "nvim-tree/nvim-web-devicons",
        }
    }

    -- indent
    use {
        "lukas-reineke/indent-blankline.nvim",
        opt = true,
        event = "BufRead",
        config = function()
            pcall(require, "plugins.indent_blankline")
        end
    }

    -- syntax
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        opt = true,
        event = "BufRead",
        config = function()
            pcall(require, "plugins.nvim_treesitter")
        end
    }

    -- commenting
    use {
        "numToStr/Comment.nvim",
        opt = true,
        event = "InsertEnter",
        config = function()
            pcall(require, "plugins.comment")
        end
    }

    -- auto close brackets
    use {
        "windwp/nvim-autopairs",
        opt = true,
        event = "InsertEnter",
        config = function()
            pcall(require, "plugins.nvim_autopairs")
        end
    }

    -- navigation
    use {
        "phaazon/hop.nvim",
        opt = true,
        event = "BufRead",
        config = function()
            pcall(require, "plugins.hop")
        end
    }

    -- key bindings
    -- use "folke/which-key.nvim"

    ------------------------------------
    -- file manager, finder, svc
    ------------------------------------

    -- file manager
    -- use {
    --     "ms-jpq/chadtree",
    --     branch = "chad",
    --     run = "python3 -m chadtree deps",
    --     opt = true,
    --     keys = { { "n", "<C-e>" } },
    --     config = function()
    --         pcall(require, "plugins.chadtree")
    --     end
    -- }

    use {
        "nvim-tree/nvim-tree.lua",
        requires = {
            "nvim-tree/nvim-web-devicons",
        },
        wants = {
            "nvim-web-devicons",
        },
        opt = true,
        keys = { { "n", "<C-e>" } },
        config = function()
            pcall(require, "plugins.nvim_tree")
        end
    }

    -- finder
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            { "nvim-lua/plenary.nvim", opt = true },
            { "nvim-telescope/telescope-ui-select.nvim", opt = true },
            -- { "nvim-telescope/telescope-fzf-native.nvim", run = "make", opt = true },
            { "nvim-telescope/telescope-fzy-native.nvim", opt = true },
        },
        wants = {
            "plenary.nvim",
            "telescope-ui-select.nvim",
            -- "telescope-fzf-native.nvim",
            "telescope-fzy-native.nvim",
            "nvim-bqf",
        },
        opt = true,
        keys = { { "n", "<leader>ff" }, { "n", "<leader>fg" }, { "n", "<leader>fb" } },
        config = function()
            pcall(require, "plugins.telescope")
        end
    }

    -- use {
    --     "ibhagwan/fzf-lua",
    --     requires = {
    --         "nvim-tree/nvim-web-devicons",
    --         -- { "junegunn/fzf", run = "./install --bin", opt = true },
    --     },
    --     wants = {
    --         "nvim-web-devicons",
    --         "nvim-bqf",
    --     },
    --     opt = true,
    --     config = function()
    --         pcall(require, "plugins.fzf_lua")
    --     end
    -- }

    -- quickfix
    use {
        "kevinhwang91/nvim-bqf",
        requires = {
            -- { "junegunn/fzf", run = "./install --bin", opt = true },
        },
        wants = {
        },
        opt = true,
        config = function()
            pcall(require, "plugins.bqf")
        end
    }

    -- svc
    use {
        "lewis6991/gitsigns.nvim",
        opt = true,
        event = "BufRead",
        config = function()
            pcall(require, "plugins.gitsigns")
        end
    }

    ------------------------------------
    -- autocompletion, debugging
    ------------------------------------

    -- autocompletion, diagnostics, formatting
    use {
        "neovim/nvim-lspconfig",
        requires = {
            { "williamboman/mason.nvim", opt = true },
            { "williamboman/mason-lspconfig.nvim", opt = true },
            -- { "VonHeikemen/lsp-zero.nvim", opt = true },
            { "hrsh7th/nvim-cmp", opt = true },
            { "hrsh7th/cmp-nvim-lsp", opt = true },
            { "hrsh7th/cmp-buffer", opt = true },
            { "hrsh7th/cmp-path", opt = true },
            { "saadparwaiz1/cmp_luasnip", opt = true },
            { "L3MON4D3/LuaSnip", opt = true },
            -- { "ms-jpq/coq_nvim", branch = "coq", opt = true },
            -- { "ms-jpq/coq.artifacts", branch = "artifacts", opt = true },
            -- { "ms-jpq/coq.thirdparty", branch = "3p", opt = true },
            { "glepnir/lspsaga.nvim", branch = "main", opt = true },
            { "jose-elias-alvarez/null-ls.nvim", opt = true },
        },
        wants = {
            "mason.nvim",
            "mason-lspconfig.nvim",
            -- "lsp-zero.nvim",
            "nvim-cmp",
            "cmp-nvim-lsp",
            "cmp-buffer",
            "cmp-path",
            "cmp_luasnip",
            "LuaSnip",
            -- "coq_nvim",
            -- "coq.artifacts",
            -- "coq.thirdparty",
            "lspsaga.nvim",
            "null-ls.nvim",
        },
        opt = true,
        event = "InsertEnter",
        config = function()
            pcall(require, "plugins.lsp")
        end,
    }

    -- debugging
    use {
        "mfussenegger/nvim-dap",
        requires = {
            { "rcarriga/nvim-dap-ui", opt = true },
            { "theHamsta/nvim-dap-virtual-text", opt = true },
        },
        wants = {
            "nvim-dap-ui",
            "nvim-dap-virtual-text",
        },
        opt = true,
        keys = { { "n", "<F5>" }, { "n", "<F9>" } }, -- triggered when start debugging
        config = function()
            pcall(require, "plugins.dap")
        end,
    }

    ------------------------------------
    -- prog. langs
    ------------------------------------

    -- latex
    use {
        "lervag/vimtex",
        opt = true,
        ft = { "tex" }, -- triggered when open *.tex file
        config = function()
            pcall(require, "plugins.vimtex")
        end
    }

    -- ---------END OF PLUGINS----------

    -- automatically set up your configuration after cloning packer.nvim
    -- put this at the end after all plugins
    if packer_bootstrap then
        packer.sync()
    end
end)

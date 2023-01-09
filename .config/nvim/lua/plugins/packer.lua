local cmd = vim.cmd
local fn = vim.fn

-- automatically install packer
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.o.runtimepath = fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath
end

-- autocommand that reloads neovim whenever you save the init.lua file
--cmd [[
--  augroup packer_user_config
--    autocmd!
--    autocmd BufWritePost init.lua source <afile> | PackerSync
--  augroup end
--]]

local packer = require ('packer')

packer.init({
	auto_reload_compiled = true,
    display = {
        compact = true,
        open_fn = function()
            return require ('packer.util').float({ border = 'none' })
        end,
    },
    git = {
		clone_timeout = 300 -- seconds
	}
})

return packer.startup(function(use)
	use 'wbthomason/packer.nvim'  -- packer can manage itself

    -- speed up loading modules
    use 'lewis6991/impatient.nvim'

    ------------------------------------
	-- gui, navigation
    ------------------------------------

    -- colorscheme
    use 'rebelot/kanagawa.nvim'

    -- status bar
    use {
        'nvim-lualine/lualine.nvim',
        requires = {
            'nvim-tree/nvim-web-devicons',
        }
    }

    -- tabs bar
    use {
        'romgrk/barbar.nvim',
        requires = {
            'nvim-tree/nvim-web-devicons',
        }
    }

    -- indent
	use 'lukas-reineke/indent-blankline.nvim'

	-- syntax
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    -- commenting
    use 'numToStr/Comment.nvim'

    -- auto close brackets
    use 'windwp/nvim-autopairs'

    -- navigation
    use 'phaazon/hop.nvim'

    ------------------------------------
	-- file manager, finder, svc
    ------------------------------------

	-- file manager
	--use {
	--	'ms-jpq/chadtree',
	--	branch = 'chad',
	--	run = 'python3 -m chadtree deps'
	--}
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        }
    }

	-- finder
	use {
		'nvim-telescope/telescope.nvim',
		requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
		}
	}

    -- use {
    --     'ibhagwan/fzf-lua',
    --     requires = {
    --         'nvim-tree/nvim-web-devicons',
    --         { 'junegunn/fzf', run = './install --bin' },
    --     }
    -- }

    -- quickfix
    use {
        'kevinhwang91/nvim-bqf',
        requires = {
            { 'junegunn/fzf', run = './install --bin' },
        }
    }

    -- svc
    use 'lewis6991/gitsigns.nvim'

    ------------------------------------
	-- autocompletion, debugging
    ------------------------------------

    -- autocompletion
    use 'neovim/nvim-lspconfig'

    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'

    -- use {
    --    'VonHeikemen/lsp-zero.nvim',
    --    requires = {
    --        'williamboman/mason.nvim',
    --        'williamboman/mason-lspconfig.nvim',
    --        'hrsh7th/nvim-cmp',
    --        'hrsh7th/cmp-nvim-lsp',
    --        'hrsh7th/cmp-buffer',
    --        'hrsh7th/cmp-path',
    --        'saadparwaiz1/cmp_luasnip',
    --        'L3MON4D3/LuaSnip',
    --    }
    -- }

    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip',
        }
    }

    -- use {
	-- 	'ms-jpq/coq_nvim',
	-- 	branch = 'coq',
	-- 	requires = {
	-- 		{ 'ms-jpq/coq.artifacts', branch = 'artifacts' },
	-- 		{ 'ms-jpq/coq.thirdparty', branch = '3p' }
	-- 	}
	-- }

    -- diagnostics
    use { 'glepnir/lspsaga.nvim', branch = 'main' }

    -- linting/formatting
    use 'jose-elias-alvarez/null-ls.nvim'

    -- debugging
    use {
        'mfussenegger/nvim-dap',
        requires = {
            'rcarriga/nvim-dap-ui',
            'theHamsta/nvim-dap-virtual-text',
        }
    }

    ------------------------------------
	-- prog. langs
    ------------------------------------

    -- latex
    use 'lervag/vimtex'

    -- ---------END OF PLUGINS----------

    -- automatically set up your configuration after cloning packer.nvim
    -- put this at the end after all plugins
    if packer_bootstrap then
		packer.sync()
	end
end)

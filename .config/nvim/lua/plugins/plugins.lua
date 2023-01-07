local cmd = vim.cmd
local fn = vim.fn

-- automatically install packer
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.o.runtimepath = fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath
end

-- autocommand that reloads neovim whenever you save the init.lua file
cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerSync
  augroup end
]]

local packer = require ('packer')

packer.init({ 
	auto_reload_compiled = true,
    git = { 
		clone_timeout = 300 -- seconds
	} 
})

return packer.startup(function(use)
	use 'wbthomason/packer.nvim'  -- packer can manage itself

    use 'nvim-tree/nvim-web-devicons'
    use 'nvim-lua/plenary.nvim'

    -- speed up loading modules
    use 'lewis6991/impatient.nvim'

    ------------------------------------
	-- gui, navigation
    ------------------------------------

    -- colorscheme
    use 'rebelot/kanagawa.nvim'

    -- status bar
    use 'nvim-lualine/lualine.nvim'

    -- tabs bar
    use 'romgrk/barbar.nvim'

    -- indent
	use 'lukas-reineke/indent-blankline.nvim'

    -- highlight
    use 'mvllow/modes.nvim'
    use 'folke/trouble.nvim'

	-- syntax
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    -- commenting
    use 'numToStr/Comment.nvim'

    -- auto close brackets
    use 'windwp/nvim-autopairs'

    -- navigation
    use 'phaazon/hop.nvim'
    use 'simrat39/symbols-outline.nvim'

    ------------------------------------
	-- file manager, finder, svc
    ------------------------------------

	-- file manager
	--use { 
	--	'ms-jpq/chadtree', 
	--	branch = 'chad', 
	--	run = 'python3 -m chadtree deps' 
	--}
    use 'nvim-tree/nvim-tree.lua'

	-- finder
	use { 
		'nvim-telescope/telescope.nvim', 
		requires = { 
			{ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
		}
	}

    use 'ibhagwan/fzf-lua'

    -- quickfix
    use {
        'junegunn/fzf',
        run = function()
            fn['fzf#install']()
        end
    }
    use 'kevinhwang91/nvim-bqf'

    -- svc
    use 'lewis6991/gitsigns.nvim'

    ------------------------------------
	-- autocompletion, debugging
    ------------------------------------

    -- autocompletion
    use 'neovim/nvim-lspconfig'
    use { 'glepnir/lspsaga.nvim', branch = 'main' }
    
    --use { 
	--	'ms-jpq/coq_nvim', 
	--	branch = 'coq',
	--	requires = {
	--		{ 'ms-jpq/coq.artifacts', branch = 'artifacts' },
	--		{ 'ms-jpq/coq.thirdparty', branch = '3p' }
	--	}
	--}
    
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip'
        }
    }

    use 'jose-elias-alvarez/null-ls.nvim'

    -- debugging
    use {
        'rcarriga/nvim-dap-ui',
        requires = {
            'mfussenegger/nvim-dap',
            'theHamsta/nvim-dap-virtual-text'
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

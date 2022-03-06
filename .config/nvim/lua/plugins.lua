-- plugin/package management

local cmd = vim.cmd  -- execute vim's commands
local fn = vim.fn  -- vim's functions

-- bootstrapping packer
local packer_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(packer_path)) > 0 then
	packer_boostrap = fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_path })
end

cmd [[packadd packer.nvim]]

-- init plugins/packages
local packer = require('packer')

packer.init({ 
	git = { 
		clone_timeout = 300 -- seconds
	} 
})

return packer.startup(function()
	use 'wbthomason/packer.nvim'

	-- gui
	--use 'folke/tokyonight.nvim'  -- colorscheme
    use 'catppuccin/nvim'

	--use {  -- tab bar
	--	'kdheepak/tabline.nvim',
	--	requires = { 
	--		{ 'nvim-lualine/lualine.nvim' },  -- status bar
	--		{ 'kyazdani42/nvim-web-devicons' }
	--	}
	--}
    
    -- status bar
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons' }
    }

    -- tabs bar
    use {
        'romgrk/barbar.nvim',
        requires = { 'kyazdani42/nvim-web-devicons' }
    }
	
	use 'lukas-reineke/indent-blankline.nvim'  -- indent

    use 'mvllow/modes.nvim'  -- highlight modes

	-- syntax
	use { 
		'nvim-treesitter/nvim-treesitter', 
		run = ':TSUpdate' 
	}
	
	use 'b3nj5m1n/kommentary'  -- commenting

    use 'windwp/nvim-autopairs'  -- auto close brackets

	-- svc
	use 'kdheepak/lazygit.nvim'

	-- file manager
	use { 
		'ms-jpq/chadtree', 
		branch = 'chad', 
		run = 'python3 -m chadtree deps' 
	}

	-- finder
	use { 
		'nvim-telescope/telescope.nvim', 
		requires = { 
			'nvim-lua/plenary.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
		}
	}

	-- autocompletion
	use { 
		'ms-jpq/coq_nvim', 
		branch = 'coq',
		requires = {
			{ 'ms-jpq/coq.artifacts', branch = 'artifacts' },
			{ 'ms-jpq/coq.thirdparty', branch = '3p' }
		}
	}

	use {
		'neovim/nvim-lspconfig',
		requires = { 'glepnir/lspsaga.nvim' } 
	}

    -- quickfix
    use {
        'kevinhwang91/nvim-bqf',
        requires = {
            { 'junegunn/fzf', run = function()
                vim.fn['fzf#install']()
            end
            }
        }
    }

	-- automatically set up configuration
	-- end of this function (after all plugins)
	if packer_boostrap then
		packer.sync()
	end
end)

-- nvim's plugins

local cmd = vim.cmd  -- execute vim's commands
local fn = vim.fn  -- vim's functions

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

-- init plugins/packages
local packer = require ('packer')

packer.init({ 
	auto_reload_compiled = true,
    git = { 
		clone_timeout = 300 -- seconds
	} 
})

return packer.startup(function(use)
	use 'wbthomason/packer.nvim'  -- packer can manage itself

    ------------------------------------
	-- gui
    ------------------------------------
	
    -- colorscheme
    --use 'catppuccin/nvim'
    use 'rebelot/kanagawa.nvim'

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

    -- indent
	use 'lukas-reineke/indent-blankline.nvim'

    -- highlight
    use 'mvllow/modes.nvim'

	-- syntax
	use { 
		'nvim-treesitter/nvim-treesitter', 
		run = ':TSUpdate' 
	}

    -- commenting
	use 'b3nj5m1n/kommentary'

    -- auto close brackets
    use 'windwp/nvim-autopairs'

    ------------------------------------
	-- file manager
    -- finder
    -- svc
    ------------------------------------
	
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

    -- svc
	use 'kdheepak/lazygit.nvim'

    use 'lewis6991/gitsigns.nvim'

    ------------------------------------
	-- autocompletion
    ------------------------------------
	
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

    ------------------------------------
	-- latex
    ------------------------------------
    
    use 'lervag/vimtex'

	-- automatically set up your configuration after cloning packer.nvim
    -- put this at the end after all plugins
    if packer_bootstrap then
		packer.sync()
	end
end)

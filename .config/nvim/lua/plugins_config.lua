-- nvim's plugins' config

local cmd = vim.cmd  -- execute vim's commands
local g = vim.g  -- global variables
local opt = vim.opt  -- global/buffer/windows-scoped options

------------------------------------
-- gui
------------------------------------

-- colorscheme
g.catppuccin_flavour = 'mocha'

require ('catppuccin').setup {
    term_colors = true,
    styles = {
        comments = {},
        conditionals = {},
        keywords = { 'bold' }
    }
}

cmd [[colorscheme catppuccin]]  -- set colorscheme

-- status bar
require ('lualine').setup {
	options = {
		theme = 'catppuccin',
		section_separators = '',
		component_separators = ''
	}
}

-- indent
opt.list = true
--opt.listchars:append('space:⋅')
--opt.listchars:append('eol:↴')

require ('indent_blankline').setup {
	space_char_blankline = ' ',
	show_current_context = true,
	show_current_context_start = true
}

-- highlight
opt.cursorline = true

require ('modes').setup()

-- syntax
require ('nvim-treesitter.configs').setup {
	highlight = {
		enable = true
	},
	incremental_selection = {
		enable = true
	},
	indent = {
		enable = true
	}
}

-- commenting
require ('kommentary.config').use_extended_mappings()

-- auto close brackets
require ('nvim-autopairs').setup()

-----------------------------------
-- file manager
-- finder
-- svc
-----------------------------------

-- finder
require ('telescope').setup {
	defaults = {
		layout_config = {
			vertical = {
				width = 0.5
			}
		}
	},
	pickers = {
		find_files = {
			theme = 'dropdown'
		}
	},
	extentions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case"
		}
	}
}

require ('telescope').load_extension('fzf')

-- svc
require ('gitsigns').setup()

-----------------------------------
-- autocompletion
-----------------------------------

-- coq
g.coq_settings = {
	auto_start = 'shut-up',  -- before require ('coq')
	display = { 
		icons = {
			spacing = 2
		}
	}
}

local coq = require ('coq')
local coq_3p = require ('coq_3p')
local lspconfig = require ('lspconfig')
local lspsaga = require ('lspsaga')

-- lsp*
local servers = {
	'ccls',				-- c/c++
	'pyright',			-- python
	'gopls',			-- go
	'rls',				-- rust
    'hls',              -- haskell
}
for _, server in pairs(servers) do
	lspconfig[server].setup(coq.lsp_ensure_capabilities())
end

lspsaga.init_lsp_saga()

-- quickfix
require ('bqf').setup()

-----------------------------------
-- latex
-----------------------------------

g.vimtex_view_method = 'zathura'

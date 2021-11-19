-- plugin/package configuration

local cmd = vim.cmd  -- execute vim's commands
local g = vim.g  -- global variables
local opt = vim.opt  -- global/buffer/windows-scoped options

------------------------------------
-- gui
------------------------------------

-- tabline
require ('tabline').setup {
	enable = true,
	options = {
		section_separators = { '', '' },
		component_separators = { '', '' },
		max_bufferline_percent = 66,
		show_tabs_always = false,
		show_devicons = true,
		show_bufnr = false,
		show_filename_only = false
	}
}

cmd [[
	set guioptions-=e
	set sessionoptions+=tabpages,globals
]]

-- lualine
require ('lualine').setup {
	options = {
		theme = 'tokyonight',
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

-- tokyonight
g.tokyonight_style = 'night'
g.tokyonight_italic_functions = true
g.tokyonight_sidebars = { 'qf', 'vista_kind', 'terminal', 'packer' }

-- set colorscheme
cmd [[colorscheme tokyonight]]

-----------------------------------
-- syntax
-----------------------------------

-- treesitter
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

-----------------------------------
-- file manager
-- finder
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
	'hls'				-- haskell
}
for _, server in pairs(servers) do
	lspconfig[server].setup(coq.lsp_ensure_capabilities())
end

lspsaga.init_lsp_saga()

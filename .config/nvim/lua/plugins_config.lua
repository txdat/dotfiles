local cmd = vim.cmd  -- execute vim's commands
local g = vim.g  -- global variables
local opt = vim.opt  -- global/buffer/windows-scoped options

------------------------------------
-- gui, navigation
------------------------------------

-- colorscheme
require ('kanagawa').setup {
    undercurl = true,           -- enable undercurls
    commentStyle = { italic = false },
    functionStyle = {},
    keywordStyle = { italic = false, bold = true },
    statementStyle = { bold = false },
    typeStyle = {},
    variablebuiltinStyle = { italic = false },
    specialReturn = true,       -- special highlight for the return keyword
    specialException = true,    -- special highlight for exception handling keywords
    transparent = false,        -- do not set background color
    dimInactive = false,        -- dim inactive window `:h hl-NormalNC`
    globalStatus = true,        -- adjust window separators highlight for laststatus=3
    terminalColors = true,      -- define vim.g.terminal_color_{0,17}
    colors = {},
    overrides = {},
    theme = "default"           -- Load "default" theme or the experimental "light" theme
}

cmd [[colorscheme kanagawa]]  -- set colorscheme

-- status bar
require ('lualine').setup {
	options = {
		theme = 'kanagawa',
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

-- navigation
require ('hop').setup()

-----------------------------------
-- file manager, finder, svc
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
	'rust_analyzer',	-- rust
    'hls',              -- haskell
    'tsserver',         -- typescript
}
for _, server in pairs(servers) do
	lspconfig[server].setup(coq.lsp_ensure_capabilities())
end

lspsaga.init_lsp_saga()

-- quickfix
require ('bqf').setup()

-----------------------------------
-- prog. langs
-----------------------------------

-- latex
g.vimtex_view_method = 'sioyek'

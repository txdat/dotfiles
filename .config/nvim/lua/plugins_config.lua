local cmd = vim.cmd  -- execute vim's commands
local opt = vim.opt  -- global/buffer/windows-scoped options

-- speed up loading modules
require ('impatient')

------------------------------------
-- gui, navigation
------------------------------------

-- colorscheme
require ('kanagawa').setup {
    undercurl = true,           -- enable undercurls
    commentStyle = { italic = false },
    functionStyle = {},
    keywordStyle = { italic = false },
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
--opt.listchars:append('space:⋅')
--opt.listchars:append('eol:↴')

require ('indent_blankline').setup {
	space_char_blankline = ' ',
	show_current_context = true,
	show_current_context_start = true,
    show_end_of_line = true
}

-- highlight
--require ('modes').setup()

-- trouble highlight
require ('trouble').setup()

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
require ('Comment').setup()

-- auto close brackets
require ('nvim-autopairs').setup()

-- navigation
require ('hop').setup()

--require ('symbols-outline').setup()

-----------------------------------
-- file manager, finder, svc
-----------------------------------

-- nvim-tree
require ('nvim-tree').setup {
    view = {
        adaptive_size = true
    }
}

-- finder
local telescope = require ('telescope')

telescope.setup {
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
			case_mode = 'smart_case'
		}
	}
}

telescope.load_extension('fzf')

require ('fzf-lua').setup {
    keymap = {
        fzf = {
            ['alt-a'] = 'select-all+accept',  -- select all and push to quickfix
            ['alt-d'] = 'deselect-all'  -- deselect all, clear quickfix
        }
    },
    winopts = {
        preview = { default = 'bat_native' }
    }
}

-- quickfix
require ('bqf').setup()

-- svc
require ('gitsigns').setup()

-----------------------------------
-- autocompletion
-----------------------------------

-- lsp
-- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
local lspconfig = require ('lspconfig')

-- coq
--vim.g.coq_settings = {
--	auto_start = 'shut-up',  -- before require ('coq')
--	display = { 
--		icons = {
--			spacing = 2
--		}
--	}
--}
--
--local coq = require ('coq')
--local coq_3p = require ('coq_3p')

-- nvim-cmp
local capabilities = require ('cmp_nvim_lsp').default_capabilities()
local cmp = require ('cmp')
local luasnip = require ('luasnip')

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    --completion = cmp.config.window.bordered(),
    --documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'luasnip' },
  },
}

local servers = {
	--'ccls',				-- c/c++
    'clangd',               -- c/c++
	'rust_analyzer',	    -- rust
	--'gopls',			    -- go
    --'hls',                -- haskell
    'pyright',			    -- python
    --'r_language_server',  -- R
    --'eslint',             -- javascript/typescript
    --'tsserver',           -- typescript
}
for _, server in pairs(servers) do
	--lspconfig[server].setup(coq.lsp_ensure_capabilities())
    
    lspconfig[server].setup {
        capabilities = capabilities
    }
end

require ('lspsaga').init_lsp_saga()

-----------------------------------
-- prog. langs
-----------------------------------

-- latex
--vim.g.vimtex_view_method = 'zathura'

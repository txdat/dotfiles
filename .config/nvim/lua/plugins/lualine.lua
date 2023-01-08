require ('lualine').setup {
	options = {
		theme = vim.g.colorscheme,
		section_separators = '',
		component_separators = '',
		globalstatus = true,
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'filename' },
		lualine_c = { 
			{ 
				'diagnostics',
				symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
			},
		 },
		lualine_x = { 'fileformat', 'encoding' },
		lualine_y = { 'branch', 'diff' },
		lualine_z = { 'location', 'progress' },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
}

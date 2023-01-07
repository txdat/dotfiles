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

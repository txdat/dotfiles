local telescope = require('telescope')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local custom_actions = {}

-- https://github.com/nvim-telescope/telescope.nvim/issues/416#issuecomment-841273053
function custom_actions.fzf_multi_select(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local n = table.getn(picker:get_multi_selection())

    if n > 1 then
        actions.send_selected_to_qflist(prompt_bufnr)
        actions.open_qflist()
    else
        -- actions.file_edit(prompt_bufnr)
        actions.select_default(prompt_bufnr)
    end
end

telescope.setup {
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
        },
        prompt_prefix = ' ',
        selection_caret = ' ',
        path_display = { 'truncate' },
        winblend = 0,
        color_devicons = true,
        layout_strategy = 'horizontal',
        layout_config = {
            horizontal = {
                prompt_position = 'top',
                preview_width = 0.55,
                results_width = 0.8,
            },
            vertical = {
                mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
        },
        border = {},
        borderchars = {
            { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
            prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
            results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
            preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        },
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
        mappings = {
            i = {
                ['<ESC>'] = actions.close,

                ['<C-j>'] = actions.move_selection_next,
                ['<C-k>'] = actions.move_selection_previous,
                ['<Down>'] = actions.move_selection_next,
                ['<Up>'] = actions.move_selection_previous,

                -- ['<CR>'] = actions.select_default,
                ['<C-x>'] = actions.select_horizontal,
                ['<C-v>'] = actions.select_vertical,
                ['<C-t>'] = actions.select_tab,

                ['<C-u>'] = actions.preview_scrolling_up,
                ['<C-d>'] = actions.preview_scrolling_down,

                ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
                ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,

                ['<A-s>'] = actions.toggle_all, -- toggle select/drop all
                ['<CR>'] = custom_actions.fzf_multi_select,
            },

            n = {
                ['<ESC>'] = actions.close,

                ['j'] = actions.move_selection_next,
                ['k'] = actions.move_selection_previous,
                ['<Down>'] = actions.move_selection_next,
                ['<Up>'] = actions.move_selection_previous,
                ['gg'] = actions.move_to_top,
                ['G'] = actions.move_to_bottom,

                -- ['<CR>'] = actions.select_default,
                ['<C-x>'] = actions.select_horizontal,
                ['<C-v>'] = actions.select_vertical,
                ['<C-t>'] = actions.select_tab,

                ['<C-u>'] = actions.preview_scrolling_up,
                ['<C-d>'] = actions.preview_scrolling_down,

                ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
                ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,

                ['<A-s>'] = actions.toggle_all, -- toggle select/drop all
                ['<CR>'] = custom_actions.fzf_multi_select,
            },
        },
    },
    pickers = {
        -- find_files = {
        --     theme = 'dropdown'
        -- },
        live_grep = {
            additional_args = function(opts)
                return { '--hidden' }
            end
        },
    },
    extentions = {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown {
                -- even more opts
                width = 1.0,
                previewer = false,
                prompt_title = false,
                borderchars = {
                    { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                    prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
                    results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
                    preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                },
            }
        },
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case'
        }
    }
}

telescope.load_extension('ui-select')
telescope.load_extension('fzf')

local keymap = require('util').keymap

keymap('n', '<leader>ff', ':Telescope find_files<CR>')
keymap('n', '<leader>fg', ':Telescope live_grep<CR>')
keymap('n', '<leader>fb', ':Telescope buffers<CR>')

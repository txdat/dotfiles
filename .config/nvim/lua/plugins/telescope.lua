local telescope = require("telescope")
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local action_layout = require("telescope.actions.layout")

local custom_actions = {}

-- https://github.com/nvim-telescope/telescope.nvim/issues/416#issuecomment-841273053
function custom_actions.multi_select(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)

    if #picker:get_multi_selection() > 1 then
        actions.send_selected_to_qflist(prompt_bufnr)
        actions.open_qflist()
    else
        -- actions.file_edit(prompt_bufnr)
        actions.select_default(prompt_bufnr)
    end
end

telescope.setup {
    defaults = {
        preview = {
            hide_on_startup = true,
        },
        vimgrep_arguments = {
            "rg",
            "--hidden",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
        },
        file_ignore_patterns = { ".git/", "node_modules/" },
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "truncate" },
        winblend = 0,
        color_devicons = true,
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.6,
                results_width = 0.8,
            },
            vertical = {
                mirror = false,
            },
            width = 0.9,
            height = 0.8,
            preview_cutoff = 120,
        },
        border = true,
        borderchars = {
            { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
            results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
            preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        },
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = previewers.buffer_previewer_maker,
        mappings = {
            i = {
                ["<C-p>"] = action_layout.toggle_preview,
                ["<ESC>"] = actions.close,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,
                -- ["<CR>"] = actions.select_default,
                ["<CR>"] = custom_actions.multi_select,
                ["<C-x>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                ["<C-t>"] = actions.select_tab,
                ["<C-s>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,
                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C-a>"] = actions.toggle_all, -- toggle select/drop all
            },
            n = {
                ["<C-p>"] = action_layout.toggle_preview,
                ["<ESC>"] = actions.close,
                ["j"] = actions.move_selection_next,
                ["k"] = actions.move_selection_previous,
                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,
                ["gg"] = actions.move_to_top,
                ["G"] = actions.move_to_bottom,
                -- ["<CR>"] = actions.select_default,
                ["<CR>"] = custom_actions.multi_select,
                ["<C-x>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                ["<C-t>"] = actions.select_tab,
                ["<C-s>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,
                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C-a>"] = actions.toggle_all, -- toggle select/drop all
            },
        },
    },
    pickers = {
        find_files = {
            hidden = true, -- show hidden files
            theme = "ivy",
        },
        live_grep = {
            theme = "ivy",
        },
        buffers = {
            theme = "ivy",
        },
    },
    extentions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                -- even more opts
                width = 1.0,
                previewer = false,
                prompt_title = false,
                border = true,
                borderchars = {
                    { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                    prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
                    results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
                    preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                },
            }
        },
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        fzy_native = {
            override_generic_sorter = true,
            override_file_sorter = true,
        },
    }
}

telescope.load_extension("ui-select")
-- telescope.load_extension("fzf")
telescope.load_extension("fzy_native")

local keymap = require("util").keymap

keymap("n", "<leader>ff", ":Telescope find_files<CR>")
keymap("n", "<leader>fg", ":Telescope live_grep<CR>")
keymap("n", "<leader>fb", ":Telescope buffers<CR>")
keymap("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>")

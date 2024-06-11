local telescope = require("telescope")
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local fb_actions = require("telescope._extensions.file_browser.actions")
local lga_actions = require("telescope-live-grep-args.actions")
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

telescope.setup({
    defaults = {
        preview = {
            hide_on_startup = true,
        },
        vimgrep_arguments = {
            "rg",
            "--hidden",
            "--color=always",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--max-columns=4096",
        },
        file_ignore_patterns = { "^.git/" },
        prompt_prefix = " ",
        selection_caret = "󰁕 ",
        path_display = { "truncate" },
        winblend = 0,
        color_devicons = true,
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                prompt_position = "bottom",
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
        -- borderchars = {
        --     { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        --     prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
        --     results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
        --     preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        -- },
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
                ["<A-k>"] = actions.preview_scrolling_up,
                ["<A-j>"] = actions.preview_scrolling_down,
                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C-a>"] = actions.toggle_all, -- toggle select/drop all
                ["<C-d>"] = actions.delete_buffer,
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
                ["<A-k>"] = actions.preview_scrolling_up,
                ["<A-j>"] = actions.preview_scrolling_down,
                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C-a>"] = actions.toggle_all, -- toggle select/drop all
                ["<C-d>"] = actions.delete_buffer,
            },
        },
    },
    pickers = {
        find_files = {
            -- hidden = true, -- show hidden files
            -- theme = "ivy",
        },
        live_grep = {
            -- theme = "ivy",
        },
        buffers = {
            -- theme = "ivy",
        },
    },
    extentions = {
        file_browser = {
            grouped = true,
            files = false,
            auto_depth = true,
            hidden = { file_browser = true, folder_browser = true },
            hide_parent_dir = true,
            collapse_dirs = true,
            quiet = true,
            hijack_netrw = true, -- disable hijack_netrw
            use_fd = true,
            git_status = true,
            mappings = {
                i = {
                    ["<A-c>"] = fb_actions.create,
                    ["<A-r>"] = fb_actions.rename,
                    ["<A-x>"] = fb_actions.move,
                    ["<A-y>"] = fb_actions.copy,
                    ["<A-d>"] = fb_actions.remove,
                    ["<CR>"] = fb_actions.open,
                    ["<A-g>"] = fb_actions.goto_parent_dir,
                    ["<A-w>"] = fb_actions.goto_cwd,
                    ["<A-f>"] = fb_actions.toggle_browser,
                    ["<A-h>"] = fb_actions.toggle_hidden,
                },
                n = {
                    ["c"] = fb_actions.create,
                    ["r"] = fb_actions.rename,
                    ["x"] = fb_actions.move,
                    ["y"] = fb_actions.copy,
                    ["d"] = fb_actions.remove,
                    ["<CR>"] = fb_actions.open,
                    ["g"] = fb_actions.goto_parent_dir,
                    ["w"] = fb_actions.goto_cwd,
                    ["f"] = fb_actions.toggle_browser,
                    ["h"] = fb_actions.toggle_hidden,
                },
            },
        },
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                width = 1.0,
                previewer = false,
                prompt_title = false,
                border = true,
                -- borderchars = {
                --     { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                --     prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
                --     results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
                --     preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                -- },
            }
        },
        live_grep_args = {
            auto_quoting = true,
            -- TODO: add custom keymaps
            mappings = {
            },
        },
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        -- fzy_native = {
        --     override_generic_sorter = true,
        --     override_file_sorter = true,
        -- },
    }
})

telescope.load_extension("file_browser")
telescope.load_extension("ui-select")
telescope.load_extension("live_grep_args")
telescope.load_extension("fzf")
-- telescope.load_extension("fzy_native")

local keymap = require("util").keymap

keymap("n", "<C-e>", ":Telescope file_browser<CR>")
keymap("n", "<leader>fs", ":Telescope git_status<CR>")
keymap("n", "<leader>ff", ":Telescope find_files<CR>")
-- keymap("n", "<leader>fg", ":Telescope live_grep<CR>")
keymap("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
keymap("n", "<leader>fb", ":Telescope buffers<CR>")
-- keymap("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>")

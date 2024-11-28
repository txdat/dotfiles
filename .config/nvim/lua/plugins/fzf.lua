local fdCmd = "fd --type f --color=always --hidden --follow --exclude .git" -- file only
local rgCmd =
"rg --color=always --hidden --follow --no-heading --with-filename --line-number --column --smart-case -g '!{.git}/*'"

require("fzf-lua").setup({
    "max-perf",
    winopts = {
        border = "none",
        backdrop = 0, -- opaque
        fullscreen = true,
        preview = {
            default = "bat_native",
            hidden = "hidden", -- hide preview
            wrap = "nowrap",
            border = "noborder",
            layout = "horizontal",
            scrollbar = false,
            title = false,
        },
    },
    fzf_opts = {
        ["--ansi"]           = "",
        ["--multi"]          = "",
        ["--no-separator"]   = "",
        ["--scrollbar"]      = "",
        ["--info"]           = "inline-right",
        ["--height"]         = "100%",
        ["--layout"]         = "reverse",
        ["--border"]         = "none",
        ["--highlight-line"] = true,
        ["--pointer"]        = "󰁕",
        ["--marker"]         = "▶",
        ["--preview-window"] = "hidden:noborder",
    },
    previewers = {
        bat_native = {
            cmd = "bat",
            args = "--color=always --style=numbers,changes",
        },
        git_diff = {
            pager = "delta --width=$FZF_PREVIEW_COLUMNS",
        }
    },
    git = {
        status = {
            previewer = "git_diff",
            preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
        },
        commits = {
            preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
        },
        bcommits = {
            preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
        },
    },
    files = {
        path_shorten = false,
        cmd          = fdCmd,
        -- formatter    = "path.filename_first",
    },
    grep = {
        prompt       = "Grep❯ ",
        input_prompt = "Grep❯ ",
        cmd          = rgCmd,
        rg_glob      = true,
        no_header    = true,
        no_header_i  = true,
        -- glob_flag      = "--iglob", -- case insensitive globs
        glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
    },
    lines = {
        previewer = false,
    },
    blines = {
        previewer = false,
    },
    tags = {
        no_header = true,
        no_header_i = true,
    },
    lsp = {
        -- cwd_only = true,
        symbols = {
            symbol_style = 3, -- kind only
        },
        code_actions = {
            previewer = "codeaction_native"
        }
    },
    diagnostics = {
        cwd_only = true,
        severity_only = "error",
        -- severity_limit = "warning",
        signs = {
            ["Error"] = { text = "", texthl = "DiagnosticError" },
            ["Warn"]  = { text = "", texthl = "DiagnosticWarn" },
            ["Info"]  = { text = "", texthl = "DiagnosticInfo" },
            ["Hint"]  = { text = "", texthl = "DiagnosticHint" },
        },
    },
    keymap = {
        fzf = {
            ["ctrl-a"] = "toggle-all",
            ["ctrl-p"] = "toggle-preview",
            ["alt-w"] = "toggle-preview-wrap",
            ["alt-j"] = "preview-page-down",
            ["alt-k"] = "preview-page-up",
        },
    },
})

-- Redraw Fzf-if window is resized
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "lua require('fzf-lua').redraw()"
})

local keymap = require("util").keymap

keymap("n", "<leader>fs", ":FzfLua git_status<CR>")
keymap("n", "<leader>fc", ":FzfLua git_bcommits<CR>")
keymap("n", "<leader>ff", ":FzfLua files<CR>")
keymap("n", "<leader>fg", ":FzfLua live_grep_glob<CR>")
-- keymap("n", "<leader>fg", ":FzfLua live_grep_native<CR>")
keymap("n", "<leader>fb", ":FzfLua buffers<CR>")
keymap("n", "<leader>fd", ":FzfLua diagnostics_workspace<CR>")

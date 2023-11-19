vim.opt.smartindent = false

require("nvim-treesitter.configs").setup {
    ensure_installed = {
        "vim",
        "lua",
        "c",
        "cpp",
        "cmake",
        "llvm",
        "cuda",
        "rust",
        "go",
        "python",
        "haskell",
        "javascript",
        "typescript",
        "latex",
        "markdown",
        "markdown_inline",
        "json",
        "yaml",
        "dockerfile",
        "terraform",
        "hcl",
        "proto",
    },
    sync_install = false,
    auto_install = false,
    ignore_install = {},
    autopairs = {
        enable = true,
    },
    autotag = {
        enable = true,
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
        -- disable = function(lang, buf)
        --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        --     if ok and stats and stats.size > 1048576 then -- skip large file (> 1MB)
        --         return true
        --     end
        -- end
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<S-CR>",
            node_decremental = "<BS>",
        },
    },
    indent = {
        enable = true,
    },
    -- textobjects = {
    --     select = {
    --         enable = true,
    --         lookahead = true,
    --         include_surrounding_whitespace = false, -- including preceeding/succeeding whitespaces
    --         -- keymap: v*
    --         keymaps = {
    --             ["ia"] = "@assignment.inner",
    --             ["aa"] = "@assignment.outer",
    --             ["la"] = "@assignment.lhs",
    --             ["ra"] = "@assignment.rhs",
    --             ["ib"] = "@block.inner",
    --             ["ab"] = "@block.outer",
    --             ["iC"] = "@call.inner",
    --             ["aC"] = "@call.outer",
    --             ["ic"] = "@class.inner",
    --             ["ac"] = "@class.outer",
    --             -- ["im"] = "@comment.inner",
    --             -- ["am"] = "@comment.outer",
    --             ["id"] = "@conditional.inner",
    --             ["ad"] = "@conditional.outer",
    --             ["if"] = "@function.inner",
    --             ["af"] = "@function.outer",
    --             ["il"] = "@loop.inner",
    --             ["al"] = "@loop.outer",
    --             ["ip"] = "@parameter.inner",
    --             ["ap"] = "@parameter.outer",
    --             ["ir"] = "@return.inner",
    --             ["ar"] = "@return.outer",
    --         },
    --     },
    --     swap = {
    --         enable = true,
    --         swap_next = {
    --             ["xp"] = "@parameter.inner",
    --         },
    --         swap_previous = {
    --             ["xP"] = "@parameter.inner",
    --         },
    --     },
    --     move = {
    --         enable = true,
    --         set_jumps = true,
    --         goto_next_start = {
    --             ["]f"] = "@function.outer",
    --             ["]c"] = "@class.outer",
    --         },
    --         goto_next_end = {
    --             ["]F"] = "@function.outer",
    --             ["]C"] = "@class.outer",
    --         },
    --         goto_previous_start = {
    --             ["[f"] = "@function.outer",
    --             ["[c"] = "@class.outer",
    --         },
    --         goto_previous_end = {
    --             ["[F"] = "@function.outer",
    --             ["[C"] = "@class.outer",
    --         },
    --     },
    --     -- lsp_interop = {
    --     --     enable = true,
    --     --     border = "none",
    --     -- },
    -- },
}

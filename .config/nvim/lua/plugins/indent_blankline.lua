local opt = vim.opt

--opt.listchars:append("space:⋅")
opt.listchars:append("eol:↴")

-- require("indent_blankline").setup({
--     char = "│",
--     space_char_blankline = " ",
--     show_current_context = true,
--     -- show_current_context_start = true,
-- })

local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require "ibl.hooks"
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#ff5454" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#e3c78a" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#80a0ff" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#de935f" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#8cc85f" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#cf87e8" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#74b2ff" })
end)

-- v3
require("ibl").setup({
    indent = { char = "│", smart_indent_cap = true },
    whitespace = { remove_blankline_trail = true },
    scope = { enabled = false, show_start = true, show_end = true },
})

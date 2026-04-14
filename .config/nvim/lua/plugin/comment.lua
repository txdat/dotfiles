local has_ts_comment, ts_comment = pcall(require, "ts_context_commentstring")

local ts_comment_pre_hook = function()
    if has_ts_comment then
        return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
    end
end

require("Comment").setup({
    pre_hook = ts_comment_pre_hook(),
    toggler = {
        line = "<A-/>",
        block = "<A-?>",
    },
    opleader = {
        line = "<A-/>",
        block = "<A-?>",
    },
    extra = {
        above = "<A-/>k",
        below = "<A-/>j",
        eol = "<A-/>l",
    },
})

if has_ts_comment then
    ts_comment.setup({
        enable_autocmd = true,
        config = {
            javascript = {
                __default = "// %s",
                jsx_element = "{/* %s */}",
                jsx_fragment = "{/* %s */}",
                jsx_attribute = "// %s",
                comment = "// %s",
            },
            typescript = { __default = "// %s", __multiline = "/* %s */" },
        },
    })

    vim.g.skip_ts_context_commentstring_module = true
end

-- insert mode key binding
local api = require("Comment.api")
local keymap = require("util").keymap

keymap({ "n", "i" }, "<A-/>", api.toggle.linewise.current)

local wk = require('which-key')

wk.setup({
    popup_mappings = {
        scroll_down = '<C-j>',
        scroll_up = '<C-k>',
    },
})

local M = {}

function M.keymap(mode, lhs, rhs, opts)
    local options = { mode = mode, noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end

    if type(rhs) == 'function' then
        wk.register({ [lhs] = { function() rhs end } }, options)
    else
        wk.register({ [lhs] = { rhs } }, options)
    end
end

return M

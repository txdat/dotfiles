local M = {}

function M.keymap(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
        -- remove 'silent' if 'expr' is set?
        -- if options['expr'] ~= nil then
        --     options['silent'] = nil
        -- end
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

function M.system_cmd(cmd)
    return vim.fn.system(cmd):gsub("\n[^\n]*$", "")
end

return M

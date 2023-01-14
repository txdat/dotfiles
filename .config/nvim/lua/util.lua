local function nvim_keymap(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

local M = {}

-- local ok, wk = pcall(require, "plugins.which_key")
-- if ok then
--     M.keymap = wk.keymap
-- else
--     M.keymap = nvim_keymap
-- end
M.keymap = nvim_keymap

function M.exec(cmd)
    local handler = io.popen(cmd)
    local res = handler:read("*a"):gsub("\n[^\n]*$", "")
    handler:close()
    return res
end

return M

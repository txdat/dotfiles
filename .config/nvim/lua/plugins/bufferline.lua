require('bufferline').setup {
    animation = false,
    auto_hide = false,
    hide = {
        extensions = false,
        inactive = false,
    },
    diagnostics = {
        { enabled = false }, -- ERROR
        { enabled = false }, -- WARN
        { enabled = false }, -- INFO
        { enabled = false }, -- HINT
    },
}

local nvim_tree_events = require('nvim-tree.events')
local nvim_tree_view = require('nvim-tree.view')
local bufferline_api = require('bufferline.api')

nvim_tree_events.subscribe('TreeOpen', function()
    bufferline_api.set_offset(nvim_tree_view.View.width + 1)
end)

nvim_tree_events.subscribe('Resize', function()
    bufferline_api.set_offset(nvim_tree_view.View.width + 1)
end)

nvim_tree_events.subscribe('TreeClose', function()
    bufferline_api.set_offset(0)
end)

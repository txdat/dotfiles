local dap = require("dap")
local dapui = require("dapui")

dapui.setup({
    icons = { expanded = "", collapsed = "", current_frame = "" },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    layouts = {
        {
            elements = {
                "scopes",
                "breakpoints",
                "stacks",
                "watches",
            },
            size = 0.25,
            position = "left",
        },
        {
            elements = {
                "repl",
                "console",
            },
            size = 0.4,
            position = "bottom",
        },
    },
    controls = {
        enabled = true,
    },
    render = {
        max_value_lines = 3,
        max_type_length = nil,
    },
    floating = {
        max_height = nil,
        max_width = nil,
        border = "none",
        mappings = {
            close = { "<Esc>" },
        },
    },
    windows = { indent = 1 },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
    dap.repl.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
    dap.repl.close()
end

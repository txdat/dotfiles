local dap = require("dap")
local dapui = require("dapui")

dapui.setup({
    controls = {
        enabled = true,
    },
    floating = {
        border = "none",
        mappings = {
            close = { "<Esc>" },
        },
    },
    layouts = {
        {
            elements = {
                "scopes",
                "breakpoints",
                "stacks",
                "watches",
            },
            position = "left",
            size = 0.25,
        },
        {
            elements = {
                "repl",
                "console",
            },
            position = "bottom",
            size = 0.4,
        },
    },
    mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "<Tab>",
    },
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

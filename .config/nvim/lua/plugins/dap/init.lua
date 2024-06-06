local dap = require("dap")

-- dap.set_log_level("DEBUG")

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "■", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "dap-repl",
    callback = function()
        require("dap.ext.autocompl").attach()
    end,
})

-- adapters
-- require("plugins.dap.adapters.cppdbg")
require("plugins.dap.adapters.lldb")
require("plugins.dap.adapters.go_delve")
require("plugins.dap.adapters.python")

-- config
require("plugins.dap.config.cpp") -- c/c++/rust
require("plugins.dap.config.go")
require("plugins.dap.config.python")

-- keymaps
local keymap = require("util").keymap

keymap("n", "<F5>", dap.continue)
keymap("n", "<S-F5>", dap.terminate)
keymap("n", "<F9>", dap.toggle_breakpoint)
keymap("n", "<S-F9>", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
keymap("n", "<F10>", dap.step_over)
keymap("n", "<F11>", dap.step_into)
keymap("n", "<S-F11>", dap.step_out)
keymap("n", "<F12>", dap.repl.toggle)
keymap("n", "<leader>dc", dap.run_to_cursor)
keymap("n", "<leader>db", dap.list_breakpoints)
keymap("n", "<leader>dbc", dap.clear_breakpoints)
keymap("n", "<leader>dl", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)

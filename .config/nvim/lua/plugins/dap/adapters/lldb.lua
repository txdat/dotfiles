local dap = require("dap")

dap.adapters.lldb = {
    name = "lldb",
    type = "executable",
    command = require("util").cmd("which lldb-vscode"),
}

vim.g.dap_cpp_adapter = "lldb"

local dap = require("dap")

dap.adapters.lldb = {
    name = "lldb",
    type = "executable",
    command = require("util").exec("which lldb-vscode"),
}

vim.g.cpp_dap_type = "lldb"

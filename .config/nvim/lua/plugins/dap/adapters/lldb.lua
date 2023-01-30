local dap = require("dap")

dap.adapters.lldb = {
    name = "lldb",
    type = "shell_cmdutable",
    command = require("util").shell_cmd("which lldb-vscode"),
}

vim.g.dap_cpp_adapter = "lldb"

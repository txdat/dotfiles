local dap = require("dap")

dap.configurations.python = {
    {
        name = "Python Debug",
        type = "python",
        request = "launch",
        program = "${file}",
        pythonPath = vim.g.python3_host_prog,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        runInTerminal = true,
        console = "integratedTerminal",
    },
}

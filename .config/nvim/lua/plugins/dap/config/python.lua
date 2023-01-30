local dap = require("dap")

dap.configurations.python = {
    {
        name = "Python debug and run",
        type = "python",
        request = "launch",
        program = "${file}",
        pythonPath = require("util").shell_cmd("which python3"),
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        runInTerminal = true,
        console = "integratedTerminal",
    },
}

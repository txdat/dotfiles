local dap = require("dap")

dap.adapters.python = {
    name = "python",
    type = "executable",
    command = require("util").shell_cmd("which python3"),
    args = { "-m", "debugpy.adapter" },
}

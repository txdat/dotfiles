local dap = require("dap")

dap.adapters.python = {
    name = "python",
    type = "shell_cmdutable";
    command = require("util").shell_cmd("which python3");
    args = { "-m", "debugpy.adapter" };
}

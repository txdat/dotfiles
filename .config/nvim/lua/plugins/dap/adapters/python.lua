local dap = require("dap")

dap.adapters.python = {
    name = "python",
    type = "executable",
    command = vim.g.python3_host_prog,
    args = { "-m", "debugpy.adapter" },
}

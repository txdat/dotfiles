local dap = require("dap")

dap.adapters.delve = {
    name = "delve",
    type = "server",
    port = 38697,
    executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:${port}" }
    },
}

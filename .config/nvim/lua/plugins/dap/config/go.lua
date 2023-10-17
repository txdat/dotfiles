local dap = require("dap")

dap.configurations.go = {
    {
        type = "delve",
        name = "Go Debug",
        request = "launch",
        program = "${file}"
    },
    {
        type = "delve",
        name = "Go Debug test", -- configuration for debugging test files
        request = "launch",
        mode = "test",
        program = "${file}"
    },
    -- works with go.mod packages and sub packages
    {
        type = "delve",
        name = "Go Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}"
    }
}

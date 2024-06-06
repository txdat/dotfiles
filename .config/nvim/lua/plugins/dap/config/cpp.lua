local dap = require("dap")

dap.configurations.cpp = {
    {
        name = "C/C++/Rust Debug",
        type = vim.g.dap_cpp_adapter,
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        stdio = { nil, nil, nil }, -- stdin/stdout/stderr
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
        -- "lldb" requires this
        -- https://github.com/mfussenegger/nvim-dap/issues/210
        -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --
        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --
        -- Otherwise you might get the following error:
        --
        --    Error on launch: Failed to attach to the target process
        --
        -- But you should be aware of the implications:
        -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        runInTerminal = true,
        console = "integratedTerminal",
    },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

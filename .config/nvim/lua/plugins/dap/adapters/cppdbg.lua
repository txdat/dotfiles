local dap = require("dap")

-- find cpptools directory
local cpptools_dir = require("util").system_cmd('find "' ..
    os.getenv('HOME') .. '/.vscode/extensions' .. '" -maxdepth 1 -name *cpptools*')

dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = cpptools_dir .. "/debugAdapters/bin/OpenDebugAD7",
}

vim.g.dap_cpp_adapter = "cppdbg"

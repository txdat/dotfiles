local dap = require('dap')

-- find cpptools directory
local cpptools_dir = require('util').exec('find "' ..
    os.getenv('HOME') .. '/.vscode/extensions' .. '" -maxdepth 1 -name *cpptools*')

dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = cpptools_dir .. '/debugAdapters/bin/OpenDebugAD7',
}

vim.g.cpp_dap_type = 'cppdbg'

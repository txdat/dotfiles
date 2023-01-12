local dap = require('dap')

dap.adapters.python = {
    name = 'python',
    type = 'executable';
    command = require('util').exec('which python3');
    args = { '-m', 'debugpy.adapter' };
}

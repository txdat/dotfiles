local dap = require ('dap')
local dapui = require ('dapui')

local keymap = require ('util').keymap

function terminate()
    dap.terminate()
    dapui.close()
end

keymap('n', '<F5>', dap.continue)
keymap('n', '<F4>', terminate)
keymap('n', '<F10>', dap.step_over)
keymap('n', '<F11>', dap.step_into)
keymap('n', '<F12>', dap.step_out)
keymap('n', '<F9>', dap.toggle_breakpoint)

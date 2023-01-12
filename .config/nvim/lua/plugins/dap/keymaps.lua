local dap = require('dap')
local dapui = require('dapui')

function dap_terminate()
    dap.repl.close()
    dap.terminate()
    dapui.close() -- force close dapui
end

function dap_set_breakpoint_cond()
    dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end

function dap_set_breakpoint_logp()
    dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end

local keymap = require('util').keymap

keymap('n', '<F5>', dap.continue)
keymap('n', '<F4>', dap_terminate)
keymap('n', '<F10>', dap.step_over)
keymap('n', '<F11>', dap.step_into)
keymap('n', '<F12>', dap.step_out)
keymap('n', '<F9>', dap.toggle_breakpoint)
keymap('n', '<leader>b', dap.toggle_breakpoint)
keymap('n', '<leader>bc', dap_set_breakpoint_cond)
keymap('n', '<leader>bl', dap_set_breakpoint_logp)

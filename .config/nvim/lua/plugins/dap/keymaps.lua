local dap = require ('dap')

local keymap = require ('util').keymap

-- vscode's keybind
keymap('n', '<F5>', dap.continue)
keymap('n', '<S-F5>', dap.terminate)
keymap('n', '<F10>', dap.step_over)
keymap('n', '<F11>', dap.step_into)
keymap('n', '<S-F11>', dap.step_out)
keymap('n', '<F9>', dap.toggle_breakpoint)

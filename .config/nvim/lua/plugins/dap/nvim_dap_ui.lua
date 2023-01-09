local dap = require ('dap')
local dapui = require ('dapui')

-- dap.set_log_level('DEBUG')

dapui.setup({
    icons = { expanded = '', collapsed = '', current_frame = '' },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        edit = 'e',
        repl = 'r',
        toggle = 't',
    },
    layouts = {
        {
            elements = {
                'scopes',
                'breakpoints',
                'stacks',
                'watches',
            },
            size = 0.25,
            position = 'left',
        },
        {
            elements = {
                { id = 'repl', size = 0.5 },
                { id = 'console', size = 0.5 },
            },
            size = 0.3,
            position = 'bottom',
        },
    },
    controls = {
        enabled = true,
    },
    render = {
        max_value_lines = 3,
    },
    floating = {
        max_width = 0.9,
        max_height = 0.5,
        border = vim.g.border_chars,
        mappings = {
            close = { 'q', '<Esc>' },
        },
    },
    windows = { indent = 1 },
})

vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'dap-repl',
    callback = function()
        require ('dap.ext.autocompl').attach()
    end,
})

dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
end

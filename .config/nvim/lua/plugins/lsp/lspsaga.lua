-- winbar
local function get_file_name(include_path)
    local file_name = require('lspsaga.symbolwinbar').get_file_name()
    if vim.fn.bufname '%' == '' then return '' end
    if include_path == false then return file_name end
    -- Else if include path: ./lsp/saga.lua -> lsp > saga.lua
    local sep = vim.loop.os_uname().sysname == 'Windows' and '\\' or '/'
    local path_list = vim.split(string.gsub(vim.fn.expand '%:~:.:h', '%%', ''), sep)
    local file_path = ''
    for _, cur in ipairs(path_list) do
        file_path = (cur == '.' or cur == '~') and '' or
            file_path .. cur .. ' ' .. '%#LspSagaWinbarSep#>%*' .. ' %*'
    end
    return file_path .. file_name
end

local function config_winbar_or_statusline()
    local exclude = {
        ['terminal'] = true,
        ['toggleterm'] = true,
        ['prompt'] = true,
        ['NvimTree'] = true,
        ['help'] = true,
    } -- Ignore float windows and exclude filetype
    if vim.api.nvim_win_get_config(0).zindex or exclude[vim.bo.filetype] then
        vim.wo.winbar = ''
    else
        local ok, lspsaga = pcall(require, 'lspsaga.symbolwinbar')
        local sym
        if ok then sym = lspsaga.get_symbol_node() end
        local win_val = ''
        win_val = get_file_name(true) -- set to true to include path
        if sym ~= nil then win_val = win_val .. sym end
        vim.wo.winbar = win_val
        -- if work in statusline
        --vim.wo.stl = win_val
    end
end

local events = { 'BufEnter', 'BufWinEnter', 'CursorMoved' }

vim.api.nvim_create_autocmd(events, {
    pattern = '*',
    callback = function() config_winbar_or_statusline() end,
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'LspsagaUpdateSymbol',
    callback = function() config_winbar_or_statusline() end,
})

require('lspsaga').init_lsp_saga({
    move_in_saga = { prev = '<C-j>', next = '<C-k>' },
    finder_action_keys = {
        quit = '<ESC>',
    },
    code_action_keys = {
        quit = '<ESC>',
    },
    definition_action_keys = {
        quit = '<ESC>',
    },
    rename_action_quit = '<ESC>',
    symbol_in_winbar = {
        in_custom = true,
        enable = true,
        click_support = function(node, clicks, button, modifiers)
            -- To see all available details: vim.pretty_print(node)
            local st = node.range.start
            local en = node.range['end']
            if button == "l" then
                if clicks == 2 then
                    -- double left click to do nothing
                else -- jump to node's starting line+char
                    vim.fn.cursor(st.line + 1, st.character + 1)
                end
            elseif button == "r" then
                if modifiers == "s" then
                    print "lspsaga" -- shift right click to print "lspsaga"
                end -- jump to node's ending line+char
                vim.fn.cursor(en.line + 1, en.character + 1)
            elseif button == "m" then
                -- middle click to visual select node
                vim.fn.cursor(st.line + 1, st.character + 1)
                vim.cmd "normal v"
                vim.fn.cursor(en.line + 1, en.character + 1)
            end
        end
    },
    show_outline = {
        win_width = 60,
    }
})

local keymap = require('util').keymap

keymap('n', '<leader>lf', ':Lspsaga lsp_finder<CR>')
keymap('n', '<leader>pd', ':Lspsaga peek_definition<CR>')
keymap('n', '<leader>so', ':Lspsaga outline<CR>')
keymap('n', '<leader>rn', ':Lspsaga rename<CR>')
keymap('n', '<leader>ca', ':Lspsaga code_action<CR>')
keymap('n', 'K', ':Lspsaga hover_doc<CR>')

-- diagnostic
local lsp_diagnostic = require('lspsaga.diagnostic')

keymap('n', '<leader>ld', ':Lspsaga show_line_diagnostics<CR>')
keymap('n', '<leader>cd', ':Lspsaga show_cursor_diagnostics<CR>')
keymap('n', '[d', ':Lspsaga diagnostic_jump_prev<CR>')
keymap('n', ']d', ':Lspsaga diagnostic_jump_next<CR>')
keymap('n', '[e', function()
    lsp_diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)
keymap('n', ']e', function()
    lsp_diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end)

-- float terminal
keymap('n', '<A-t>', ':Lspsaga open_floaterm<CR>')
keymap('n', '<A-g>', ':Lspsaga open_floaterm lazygit<CR>') -- no .git will falling back to term
keymap('t', '<A-t>', [[<C-\><C-n>:Lspsaga close_floaterm<CR>]]) -- close

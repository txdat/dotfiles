local api = vim.api

-- quickfix replace
api.nvim_create_user_command('QfReplace', function(opts)
    api.nvim_command(string.format('cfdo %%s/%s/%s/gI', opts.fargs[1], opts.fargs[2])) -- case sensitive
    api.nvim_command('cfdo update') -- ':cfdo undo'
end, { nargs = '*' })

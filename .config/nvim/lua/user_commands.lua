local api = vim.api

-- https://elanmed.dev/blog/global-find-and-replace-in-neovim
api.nvim_create_user_command('FindAndReplace', function(opts)
    api.nvim_command(string.format('cfdo %%s/%s/%s/gI', opts.fargs[1], opts.fargs[2]))  -- case sensitive
    api.nvim_command('cfdo update')  -- ':cfdo undo'
end, { nargs = '*' })

local api = vim.api

-- https://elanmed.dev/blog/global-find-and-replace-in-neovim
api.nvim_create_user_command('FindAndReplace', function(opts)
    api.nvim_command(string.format('cdo s/%s/%s/gc', opts.fargs[1], opts.fargs[2]))
    api.nvim_command('cfdo update')
end, { nargs = '*' })

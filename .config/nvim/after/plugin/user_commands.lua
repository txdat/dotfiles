local api = vim.api

-- quickfix replace
api.nvim_create_user_command("QfReplace", function(opts)
    api.nvim_command(string.format("cfdo %%s/%s/%s/%s", opts.fargs[1], opts.fargs[2], opts.fargs[3] or "c | up"))
    api.nvim_command("cfdo update")
end, { nargs = "*" })

-- set tab to 2 spaces
api.nvim_create_user_command("SetIndent", function(opts)
    local s = opts.fargs[1]
    api.nvim_command(string.format("set tabstop=%s softtabstop=%s shiftwidth=%s", s, s, s))
end, { nargs = "*" })

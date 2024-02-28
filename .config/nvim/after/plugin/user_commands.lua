local api = vim.api

-- quickfix replace
-- e.g. ':QfReplace Jetbrains\ Mono JetbrainsMono\ Nerd\ Font'
api.nvim_create_user_command("QfReplace", function(opts)
    api.nvim_command(string.format("cfdo %%s/%s/%s/gI", opts.fargs[1], opts.fargs[2])) -- case sensitive
    api.nvim_command("cfdo update")                                                    -- ":cfdo undo"
end, { nargs = "*" })

-- set tab to 2 spaces
api.nvim_create_user_command("SetTab", function(opts)
    local s = opts.fargs[1]
    api.nvim_command(string.format("set tabstop=%s softtabstop=%s shiftwidth=%s", s, s, s))
end, { nargs = "*" })

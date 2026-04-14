local api = vim.api

-- quickfix replace
api.nvim_create_user_command("QfReplace", function(opts)
    api.nvim_command(string.format("cfdo %%s/%s/%s/%s | update", opts.fargs[1], opts.fargs[2], opts.fargs[3] or "g"))
end, { nargs = "*" })

-- set tab to 2 spaces
api.nvim_create_user_command("SetIndent", function(opts)
    local s = opts.fargs[1]
    api.nvim_command(string.format("set tabstop=%s softtabstop=%s shiftwidth=%s", s, s, s))
end, { nargs = "*" })

-- difftool
vim.api.nvim_create_user_command('Diff', function(opts)
  if vim.tbl_count(opts.fargs) ~= 2 then
    return
  end

  vim.cmd 'tabnew'
  vim.cmd.packadd 'nvim.difftool'
  require('difftool').open(opts.fargs[1], opts.fargs[2], {
    rename = {
      detect = false,
    },
    ignore = { '.git' },
  })
end, { complete = 'file', nargs = '*' })

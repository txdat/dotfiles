require ('fzf-lua').setup {
    keymap = {
        fzf = {
            ['alt-a'] = 'select-all+accept',  -- select all and push to quickfix
            ['alt-d'] = 'deselect-all'  -- deselect all, clear quickfix
        }
    },
    winopts = {
        preview = { default = 'bat_native' }
    }
}

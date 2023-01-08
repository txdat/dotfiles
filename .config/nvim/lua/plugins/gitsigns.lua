require ('gitsigns').setup()

local keymap = require ('util').keymap

keymap('n', '<leader>df', ':Gitsigns diffthis<CR>')
keymap('n', '<leader>di', ':Gitsigns preview_hunk_inline<CR>')

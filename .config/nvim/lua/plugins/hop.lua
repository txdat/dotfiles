require ('hop').setup()

local keymap = require ('util').keymap

keymap('n', 'f', ':HopChar1CurrentLineAC<CR>')
keymap('n', 'F', ':HopChar1CurrentLineBC<CR>')
keymap('n', 's', ':HopChar2AC<CR>')
keymap('n', 'S', ':HopChar2BC<CR>')

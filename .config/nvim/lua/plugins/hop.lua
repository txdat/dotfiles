require("hop").setup()

local keymap = require("util").keymap

keymap("n", "f", ":HopChar1CurrentLineAC<CR>")
keymap("n", "F", ":HopChar1CurrentLineBC<CR>")
keymap("n", "g", ":HopChar2AC<CR>")
keymap("n", "G", ":HopChar2BC<CR>")

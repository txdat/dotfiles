require("hop").setup()

local keymap = require("util").keymap

keymap("n", "f", ":HopChar1CurrentLineAC<CR>")
keymap("n", "F", ":HopChar1CurrentLineBC<CR>")
keymap("n", "t", ":HopChar2AC<CR>")
keymap("n", "T", ":HopChar2BC<CR>")

require("hop").setup()

local keymap = require("util").keymap

keymap("n", "s", ":HopChar1CurrentLineAC<CR>")
keymap("n", "S", ":HopChar1CurrentLineBC<CR>")
keymap("n", "f", ":HopChar2AC<CR>")
keymap("n", "F", ":HopChar2BC<CR>")

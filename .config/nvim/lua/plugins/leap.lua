require("leap").add_default_mappings(true)
require("flit").setup({ labeled_modes = "nx" })

vim.keymap.del({ "x", "o" }, "x")
vim.keymap.del({ "x", "o" }, "X")

require("nvim-surround").setup({
    keymaps = {
        insert = false,
        insert_line = false,
        normal = "sa",
        normal_cur = "saa",
        normal_line = "sA",
        normal_cur_line = "sAA",
        visual = "sa",
        visual_line = "sA",
        delete = "sd",
        change = "sc",
        change_line = "sC",
    },
})

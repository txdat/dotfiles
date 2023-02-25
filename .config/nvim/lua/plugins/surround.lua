require("nvim-surround").setup({
    keymaps = {
        insert = "<A-s>a",
        insert_line = "<A-s>A",
        normal = "sa",
        normal_cur = "sca",
        normal_line = "sA",
        normal_cur_line = "scA",
        visual = "sa",
        visual_line = "sA",
        delete = "sd",
        change = "sc",
    },
})

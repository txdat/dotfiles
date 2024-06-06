require("nvim-surround").setup({
    keymaps = {
        insert = false,
        insert_line = false,
        normal = "sa",
        normal_cur = "sa",
        normal_line = "sal",
        normal_cur_line = "sal",
        visual = "sa",
        visual_line = "sal",
        delete = "sd",
        change = "sr",
        change_line = "srl",
    },
})

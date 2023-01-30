require("lsp_signature").setup({
    bind = true,
    doc_lines = 0,
    floating_window = true,
    floating_window_above_cur_line = true,
    hint_enable = false,
    hint_prefix = "⛏️  ",
    handler_opts = {
        border = "single",
    },
    extra_trigger_chars = { "(", "," },
    transparency = nil,
    shadow_blend = 0,
    toggle_key = "<A-s>",
})

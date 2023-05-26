local opts = {
    RRGGBB = true,
    RRGGBBAA = true,
    RGB = false,
    names = false,
    rgb_fn = true,
    rgba_fn = true,
    mode = "background",
}

require("colorizer").setup({
    html = opts,
    css = opts,
    javascript = opts,
    typescript = opts,
})

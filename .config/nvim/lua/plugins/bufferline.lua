require("bufferline").setup {
    animation = false,
    auto_hide = false,
    hide = {
        extensions = false,
        inactive = false,
    },
    diagnostics = {
        { enabled = false }, -- ERROR
        { enabled = false }, -- WARN
        { enabled = false }, -- INFO
        { enabled = false }, -- HINT
    },
}

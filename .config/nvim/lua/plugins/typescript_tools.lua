require("typescript-tools").setup({
    settings = {
        -- tsserver_plugins = { "@styled/typescript-styled-plugin" },
        complete_function_calls = false,
        code_lens = "off",
        jsx_close_tag = { enable = true }, -- not compatible with nvim-ts-autotag
    },
})

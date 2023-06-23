require("typescript-tools").setup({
    settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        -- tsserver_plugins = { "typescript-styled-plugin" },
    },
})

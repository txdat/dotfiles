local api = vim.api
local metals_config = require("metals").bare_config()

metals_config.settings = {
    useGlobalExecutable = true,
    showImplicitArguments = true,
    excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

-- capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- dap
local have_dap, dap = pcall(require, "dap")
if have_dap then
    dap.configurations.scala = {
        {
            type = "scala",
            request = "launch",
            name = "RunOrTest",
            metals = {
                runType = "runOrTestFile",
                --args = { "firstArg", "secondArg", "thirdArg" },
            },
        },
        {
            type = "scala",
            request = "launch",
            name = "Test target",
            metals = {
                runType = "testTarget",
            },
        },
    }

    metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()
    end
end

local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
api.nvim_create_autocmd("FileType", {
    -- may conflict with nvim-jdtls for java
    pattern = { "scala", "sbt", "java" },
    callback = function()
        require("metals").initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
})

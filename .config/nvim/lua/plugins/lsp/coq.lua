vim.g.coq_settings = {
	auto_start = 'shut-up',
	display = { 
		icons = {
			spacing = 2
		}
	}
}

local coq = require ('coq')
local lspconfig = require ('lspconfig')

local lsp_servers = require ('plugins.lsp.lsp_servers').servers

for _, server in pairs(lsp_servers) do
    lspconfig[server].setup(coq.lsp_ensure_capabilities())
end

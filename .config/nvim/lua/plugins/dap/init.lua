require ('plugins.dap.nvim_dap_ui')
require ('plugins.dap.nvim_dap_virtual_text')
require ('plugins.dap.keymaps')

-- adapters
-- select 1 of 2 for cpp
--require ('plugins.dap.adapters.cppdbg')
require ('plugins.dap.adapters.lldb')

require ('plugins.dap.adapters.python')

-- config
require ('plugins.dap.config.cpp')  -- config for c/c++/rust
require ('plugins.dap.config.python')

vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/hrsh7th/cmp-nvim-lsp' },
  { src = 'https://github.com/hrsh7th/cmp-buffer' },
  { src = 'https://github.com/hrsh7th/cmp-path' },
  { src = 'https://github.com/hrsh7th/nvim-cmp' },
})

require("plugin.treesitter")
require("plugin.autopairs")
require("plugin.fzf")
require("plugin.cmp")

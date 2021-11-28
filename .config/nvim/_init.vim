"****************************************
"Configurations
"****************************************

set number
set encoding=utf-8 fileencoding=utf-8
set tabstop=4 softtabstop=0 shiftwidth=4 smarttab expandtab
set guicursor=i:block
filetype plugin indent on
syntax on

"****************************************
"Plugins
"****************************************

let vimplug_path=expand('~/.config/nvim/autoload/plug.vim')
if !filereadable(vimplug_path)
	silent exec "!\curl -fLo".vimplug_path."--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
endif

call plug#begin(expand('~/.config/nvim/plugged'))

"Plug 'arcticicestudio/nord-vim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
Plug 'hoob3rt/lualine.nvim'

Plug 'sheerun/vim-polyglot'

Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}

Plug 'kdheepak/lazygit.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'jiangmiao/auto-pairs'

Plug 'preservim/nerdcommenter'

Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'

call plug#end()

"tokyonight
let g:tokyonight_style="night"
let g:tokyonight_italic_functions=1
let g:tokyonight_sidebars=[ "qf", "vista_kind", "terminal", "packer" ]

silent! colorscheme tokyonight

"airline
"let g:airline_theme='powerlineish'
"let g:airline_skip_empty_sections=1
"let g:airline#extensions#branch#enabled=1
"let g:airline#extensions#ale#enabled=1
"let g:airline#extensions#tabline#enabled=1
"let g:airline#extensions#tagbar#enabled=1
"let g:airline#extensions#virtualenv#enabled=1

"lualine
lua <<EOF
require('lualine').setup {
	options = { theme = 'auto' }
}
EOF

"treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
	highlight = { enable = true },
	incremental_selection = { enable = true },
	indent = { enable = true }
}
EOF

"coq
let g:coq_settings = { 'auto_start': v:true, 'display.icons.spacing': 2 }

"lsp
lua << EOF
local lsp = require "lspconfig"
local coq = require "coq"
local saga = require "lspsaga"

local servers = { 'ccls', 'pyright', 'gopls', 'rls', 'hls' }
for _, server in pairs(servers) do
	lsp[server].setup(coq.lsp_ensure_capabilities())
end

saga.init_lsp_saga()
EOF

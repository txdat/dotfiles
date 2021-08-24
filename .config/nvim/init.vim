"****************************************
"Configurations
"****************************************

set number
set encoding=utf-8 fileencoding=utf-8
set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4 smarttab
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

Plug 'arcticicestudio/nord-vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'sheerun/vim-polyglot'

Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}

Plug 'kdheepak/lazygit.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'jiangmiao/auto-pairs'

Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

Plug 'neovim/nvim-lspconfig'

call plug#end()

"nord
silent! colorscheme nord

"airline
let g:airline_theme='powerlineish'
let g:airline_skip_empty_sections=1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#ale#enabled=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tagbar#enabled=1
let g:airline#extensions#virtualenv#enabled=1

"treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
	highlight = { enable = true },
	incremental_selection = { enable = true },
	indent = { enable = true }
}
EOF

"coq
let g:coq_settings = { 'auto_start': v:true }

"lsp
lua << EOF
require'lspconfig'.ccls.setup{}
require'lspconfig'.pyright.setup{}
require'lspconfig'.rls.setup{}
EOF

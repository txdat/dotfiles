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

Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'

Plug 'kdheepak/lazygit.nvim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'jiangmiao/auto-pairs'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

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

"lsp
lua << EOF
require'lspconfig'.ccls.setup{}
require'lspconfig'.pyright.setup{}
EOF

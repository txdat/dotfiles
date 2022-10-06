set number
set encoding=utf-8 fileencoding=utf-8
set tabstop=4 softtabstop=0 shiftwidth=4 smarttab expandtab
filetype plugin indent on

if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

syntax on
set termguicolors

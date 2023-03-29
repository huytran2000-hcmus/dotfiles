" Intergrate with vim
"set runtimepath^=~/.vim runtimepath+=~/.vim/after
"let &packpath = &runtimepath
"source ~/.vimrc

" Basic setting
" set backspace=indent,eol,start
" set history=50
" set ruler
" set showcmd
" 
" set wrap
" set linebreak
" set textwidth=120
" set colorcolumn=100
" set path+=~/.config/nvim/
" set path+=~/.config/nvim/lua/
" set path+=~/.config/nvim/lua/mine/
" set path+=~/.config/nvim/lua/mine/config
" set path+=~/.config/nvim/lua/mine/plugins/
" set path+=~/.config/nvim/after/plugin/
" set path+=~/.config/nvim/plugin/

" set cmdheight=0

" set clipboard+=unnamedplus
"let g:clipboard = {
"  \   'name': 'myClipboard',
"  \   'copy': {
"  \      '+': ['tmux', 'load-buffer', '-'],
"  \      '*': ['tmux', 'load-buffer', '-'],
"  \    },
"  \   'paste': {
"  \      '+': ['tmux', 'save-buffer', '-'],
"  \      '*': ['tmux', 'save-buffer', '-'],
"  \   },
"  \   'cache_enabled': 1,
"  \ }

" Command

" Load lua module
:lua require("mine")


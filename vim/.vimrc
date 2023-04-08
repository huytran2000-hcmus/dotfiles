let mapleader = " "
set number
set relativenumber

syntax on
colorscheme industry

set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4

set autoindent

set incsearch
set hlsearch
set ignorecase smartcase

set wrap
set linebreak
set textwidth=120
set colorcolumn=100

set scrolloff=3
set sidescroll=10

"set spell spelllang=en_us
nnoremap <leader>f 1z=

set hidden

set listchars=tab:>\ ,trail:-,nbsp:+

set backspace=indent,eol,start
set history=50
set ruler
set showcmd

set wrap
set linebreak
set textwidth=120

" Buffer
nnoremap <leader>n :bn<ENTER>
nnoremap <leader>3 :bp<ENTER>

" Write file with sudo
command! W w !sudo tee % > /dev/null

" Netrw
set autochdir
" let g:netrw_keepdir = 0
let g:netrw_winsize = 30
let g:netrw_banner = 0
let g:netrw_localcopydircmd = 'cp -r'
hi! link netrwMarkFile Search
nnoremap <leader>e :Lexplore %:p:h<CR>

function! NetrwMapping()
        nmap <buffer> p -^
        nmap <buffer> h u

        nmap <buffer> . gh
        nmap <buffer> <Tab> <C-w>z

        nmap <buffer> l <CR>
        nmap <buffer> l v:Lexplore<CR>

        nmap <buffer> <leader>e :Lexplore<CR>

        nmap <buffer> n %:tabnew<CR>:b#<CR>

        nmap <buffer> q :close<CR>
endfunction

augroup netrw_mapping
        autocmd!
        autocmd filetype netrw call NetrwMapping()
augroup END

" Escape term mode
tnoremap <Esc><Esc> <C-\><C-n>

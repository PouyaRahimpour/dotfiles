set nu
set relativenumber

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

let mapleader=" "

nnoremap <leader>y <cmd>[["+y]]<cr>
vnoremap <leader>y <cmd>[["+y]]<cr>

vnoremap jk <esc>
inoremap jk <esc>

nnoremap <leader>3 <esc>:w <cr><cmd>!g++ -ggdb -fsanitize=address,undefined -std=c++17 -DLOCAL -O2 %:~ -o %:p:r && %:~:r < %:~:h/inp <cr>
inoremap <leader>3 <esc>:w <cr><cmd>!g++ -ggdb -fsanitize=address,undefined -std=c++17 -DLOCAL -O2 %:~ -o %:p:r && %:~:r < %:~:h/inp <cr>
vnoremap <leader>3 <esc>:w <cr><cmd>!g++ -ggdb -fsanitize=address,undefined -std=c++17 -DLOCAL -O2 %:~ -o %:p:r && %:~:r < %:~:h/inp <cr>

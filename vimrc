syntax on
set number
set tabstop=2
set incsearch
set hlsearch
" retab
colorscheme evening
:nmap <C-n> :bnext<CR>
:nmap <C-p> :bprev<CR>
:nmap \q :nohlsearch<CR>
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p


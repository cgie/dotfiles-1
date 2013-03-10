syntax on
set number
set tabstop=2
set incsearch
set hlsearch
" set cursorline
set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)
" retab
set background=dark
colorscheme evening
:nmap <C-n> :bnext<CR>
:nmap <C-p> :bprev<CR>
:nmap \q :nohlsearch<CR>
:nmap Y y$
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p


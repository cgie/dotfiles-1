syntax on

set number
set tabstop=2
set incsearch
set hlsearch
set numberwidth=4

" set cursorline
set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)

" retab
set background=dark

colorscheme evening

:nmap <C-n> :bnext<CR>
:nmap <C-p> :bprev<CR>
:nmap \q :nohlsearch<CR>
:nmap Y y$

" autocmd VimEnter * NERDTree
" autocmd VimEnter * wincmd p

" encodinf
set fileencoding=utf-8

" indentation and tab settings
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4

" set expandtab for Python file
autocmd FileType python setlocal expandtab
autocmd FileType php setlocal expandtab

" line numbers

:hi LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" synrax highlighting
syntax on

" highlight trailing spaces
set listchars=eol:¶,tab:>-,trail:.,extends:>,precedes:<

" current line highlight
set ruler
set cursorline

" status line
set laststatus=2
:hi StatusLine ctermbg=None ctermfg=DarkGrey

" 80 char
highlight OverLength ctermbg=LightMagenta ctermfg=LightGrey guibg=#592929
match OverLength /\%80v.\+/


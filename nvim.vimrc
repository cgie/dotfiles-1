"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" be iMproved, required
set nocompatible

" cd $WORKSPACES
" cd $DOWNLOADS
" cd $HOME

"" Enable syntax highlighting
syntax enable

"" Endofline (that's an $, not the emty line)
" set endofline

"" Sets how many lines of history VIM has to remember
set history=700

"" Enable filetype plugins
filetype plugin on
filetype indent on

"" Vundle required
" filetype off

"" Set to auto read when a file is changed from the outside
set autoread

"" With a map leader it's possible to do extra key combinations
"" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

"" Non recursive mapping
" noremap \ ,

"" Fast saving
" nmap <leader>w :w!<cr>

" set guifont=Monaco\ 12

"" Set utf8 as standard encoding and en_US as the standard language
" set encoding=utf8

"" Use Unix as the standard file type
set ffs=unix,dos,mac

"" Provide some context when editing
"" The 'scrolloff' (scroll offset) option determines the minimum number of
"" screen lines that you would like above and below the cursor. By default,
"" "'scrolloff' is 0 which means that you can move the cursor to any line in
"" the window without causing scrolling.
set scrolloff=3

"" don't use Ex mode, use Q for formatting
" map Q gq

set colorcolumn=80
" :highlight ColorColumn ctermbg=lightgrey guibg=lightgrey

"" Mappings
"" Commands                        Mode
"" --------                        ----
"" nmap, nnoremap, nunmap          Normal mode
"" imap, inoremap, iunmap          Insert and Replace mode
"" vmap, vnoremap, vunmap          Visual and Select mode
"" xmap, xnoremap, xunmap          Visual mode
"" smap, snoremap, sunmap          Select mode
"" cmap, cnoremap, cunmap          Command-line mode
"" omap, onoremap, ounmap          Operator pending mode

"" Sometimes it is helpful if your working directory is always the same as
"" the file you are editing. To achieve this, put the following in your
"" vimrc:

set autochdir

"" Unfortunately, when this option is set
"" some plugins may not work correctly if they make assumptions about the
"" current directory. Sometimes, as an alternative to setting autochdir,
"" the following command gives better results:
" autocmd BufEnter * silent! lcd %:p:hj

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Backup files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set nobackup
set backupdir=~/.vim.backup,/tmp
set directory=~/.vim.backup,/tmp

"" Where nowritebackup changes the default 'save' behavior of Vim, which is:
""  - write buffer to new file
""  - delete the original file
""  - rename the new file
"" and makes Vim write the buffer to the original file (resulting in the risk
"" of destroying it in case of an I/O error)
set nowritebackup

"" Vim stores the things you changed in a swap file.  Using the original file
"" you started from plus the swap file you can mostly recover your work.
"" You can see the name of the current swap file being used with the command:
""  :sw[apname]
" set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Leadering the Space
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let mapleader = "\<Space>"

"" Type <Space>o to open a new file:
" nnoremap <Leader>o :CtrlP<CR>

"" Type <Space>w to save file:
" nnoremap <Leader>w :w<CR>

"" Copy & paste to system clipboard with <Space>p and <Space>y:
" vmap <Leader>y "+y
" vmap <Leader>d "+d
" nmap <Leader>p "+p
" nmap <Leader>P "+P
" vmap <Leader>p "+p
" vmap <Leader>P "+P

"" Enter visual line mode with <Space><Space>:
" nmap <Leader><Leader> V

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Ignore Rubinius, Sass cache files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set wildignore=*.swp
set wildignore+=*/tmp/*,*.so,*.zip
set wildignore+=tmp/**,*.rbc,.rbx,*.scssc,*.sassc
set wildignore+=*.so,*.swp,*.zip
set wildignore+=*/.Trash/**,*.pdf,*.dmg,*/Library/**,*/.rbenv/**
set wildignore+=*DS_Store*

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Folding configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" The 'foldmethod' option (abbreviated to 'fdm') is local to each window.
"" It determines what kind of folding applies in the current window.
"" Commonly used values are:
"" manual – folds must be defined by entering commands (such as zf)
"" indent – groups of lines with the same indent form a fold
"" syntax – folds are defined by syntax highlighting
"" expr – folds are defined by a user-defined expression
set foldmethod=indent

"" When you set foldmethod to something like indent or syntax, which
"" defines folds as soon as you open the file, all folds are closed by
"" default. If you set the foldlevel to a high setting, files are always
"" loaded with opened folds. For example, you could put the settings below
"" in your vimrc: set foldmethod=indent set foldlevel=20 This is not ideal,
"" however, as the foldlevel option is local to the window, and
"" additionally gets modified every time you use a command that adjusts the
"" fold level, like zm, zr, and their friends.  A better method is to set
"" the foldlevel whenever you load a buffer into a window. You could use
"" autocommands for this, but there is a built-in option that does this for
"" you automatically:
set foldlevelstart=20

" noremap <silent> <Space> za
" vnoremap <silent> <Space> za<Esc>
" map <Leader>fs :set foldmethod=syntax<cr>
" map <Leader>fm :set foldmethod=manual<cr>

"" Indent folding with manual folds
"" If you like the convenience of having Vim define folds automatically by
"" indent level, but would also like to create folds manually, you can get
"" both by putting this in your vimrc:

" augroup vimrc
"   au BufReadPre * setlocal foldmethod=indent
"   au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
" augroup END

"" The first autocommand sets 'indent' as the fold method before a file is
"" loaded, so that indent-based folds will be defined. The second one allows
"" you to manually create folds while editing. It's executed after the modeline
"" is read, so it won't change the fold method if the modeline set the fold
"" method to something else like 'marker' or 'syntax'.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Highlight the screen column/line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocursorcolumn
set nocursorline

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Limit the syntax highlight to check
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" Vim supports highlighting synchronization by searching a variable amount
"" backwards from the current position for a recognized syntax state.
syntax sync minlines=256

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Long lines problem
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Syntax coloring lines that are too long just slows down the world
set synmaxcol=300

"" you got a fast terminal
" set ttyfast
" set ttyscroll=3
"" to avoid scrolling problems
" set lazyredraw

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Nvim terminal configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" http://neovim.io/doc/user/nvim_terminal_emulator.html
tnoremap <Esc> <C-\><C-n>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Regex engine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" Any version older than and including Vim 7.3.969 has the old regex
"" engine. Add in set re=1 to your vimrc to force the old regex engine on
"" any version newer.
set re=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" =>  Switch to AlternateFile
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader><leader> <c-^>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" =>  Find merge conflict marker
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" nmap <silent> <leader>cf <ESC>/\v^[<=>]{7}( .*\|$)<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Highlight the screen column of the cursor with CursorColum
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Easier navigation between split windows
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" nnoremap <c-j> <c-w>j
" nnoremap <c-k> <c-w>k
" nnoremap <c-h> <c-w>h
" nnoremap <c-l> <c-w>l

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Disable cursor keys in normal mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Left> gT
map <Right> gt
map <Up> :echo "no!"<cr>
map <Down> :echo "no!"<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" map! jj <esc>
" map! ii <esc>
nmap oo o<esc>k
nmap OO O<esc>j
" nmap /" cs'"
" nmap /' cs"'
" nmap <silent> <Leader>w :write<CR>
" nmap <silent> <Leader>q :quit<CR>
" nmap <silent> <Leader>d :bd!<CR>
" command! Q q
" command! W w

"" Command-t Tmux fix
" map <Esc>[B <Down>

"" Copy to system clipboard
map <leader>y "*y

"" Yank from cursor to end of line
nnoremap Y y$

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Ctag
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" nnoremap <f5> :!ctags -R<CR>
" nnoremap <f6> :!open -a Google\ Chrome % <CR>
" map <leader>j g<c-]>
" nnoremap <silent><Leader>j <C-w><C-]><C-w>T
" map <leader>tt <c-t>
" set tags+=gems.tags
" map _ :TagbarToggle<CR>
" nnoremap <leader>. :CtrlPTag<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Helpers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" Toggle wrap
" function! AutoWrapToggle()
"   if &formatoptions =~ 't'
"     set fo-=t
"   else
"     set fo+=t
"   endif
" endfunction

"" Clear the search buffer when hitting return
" function! MapCR()
"   nnoremap <cr> :nohlsearch<cr>
" endfunction
" call MapCR()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Movement notes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" h   move one character left
"" j   move one row down
"" k   move one row up
"" l   move one character right
"" w   move to beginning of next word
"" b   move to beginning of previous word
"" e   move to end of word
"" W   move to beginning of next word after a whitespace
"" B   move to beginning of previous word before a whitespace
"" E   move to end of word before a whitespace
"
"" 0   move to beginning of line
"" $   move to end of line
"" ^   move to first non-blank char of the line
"" _   same as above, but can take a count to go to a different line
"" g_  move to last non-blank char of the line (can also take a count as above)
"
"" gg  move to first line
"" G   move to last line
"" nG  move to n'th line of file (where n is a number)
"
"" H   move to top of screen
"" M   move to middle of screen
"" L   move to bottom of screen
"
"" z.  put the line with the cursor at the center
"" zt  put the line with the cursor at the top
"" zb  put the line with the cursor at the bottom of the screen
"
"" Ctrl-D  move half-page down
"" Ctrl-U  move half-page up
"" Ctrl-B  page up
"" Ctrl-F  page down
"" Ctrl-o  jump to last cursor position
"" Ctrl-i  jump to next cursor position
"
"" n   next matching search pattern
"" N   previous matching search pattern
"" *   next word under cursor
"" #   previous word under cursor
"" g*  next matching search pattern under cursor
"" g#  previous matching search pattern under cursor
"
"" %   jump to matching bracket { } [ ] ( )

"" The % command jumps to the match of the item under the cursor. Position
"" the cursor on the opening (or closing) paren and use y% for yanking or
"" d% for deleting everything from the cursor to the matching paren.
""
"" This works because % is a 'motion command', so it can be used anywhere
"" vim expects such a command. From :help y:
""
"" ["x]y{motion}       Yank {motion} text [into register x].  When no
""                     characters are to be yanked (e.g., 'y0' in column 1),
""                     this is an error when 'cpoptions' includes the 'E'
""                     flag.
"" By default, 'item' includes brackets, braces, parens, C-style comments
"" and various precompiler statements (#ifdef, etc.).

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Reformatting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" These are useful to reformat text paragraphs or chunks of code
""
""     V=  - select text, then reformat with =
""     =   - will correct alignment of code
""     ==  - one line;
""     gq  - reformat paragraph
"" Options to change how automatic formatting is done:
""
""     :set formatoptions (default 'tcq')
""         t - textwidth
""         c - comments (plus leader -- see :help comments)
""         q - allogw 'gq' to work
""         n - numbered lists
""         2 - keep second line indent
""         1 - single letter words on next line
""         r - (in mail) comment leader after
"" Other related options:
""
""     :set wrapmargin
""     :set textwidth

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Packages
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" Plug - minimalist Vim Plugin Manager
"" https://github.com/junegunn/vim-plug
if empty(glob("~/.vim/autoload/plug.vim"))
  execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin('~/.vim/plugged')

  "" https://github.com/VundleVim/Vundle.vim
  "" Vundle, the plug-in manager for Vim
  " Plug 'vundlevim/vundle.vim'

  "" https://github.com/Peeja/vim-cdo
  "" Vim commands to run a command over every entry in the quickfix list (:Cdo)
  "" or location list (:Ldo)
  " Plug 'Peeja/vim-cdo'

  "" https://github.com/Raimondi/delimitMate
  "" Vim plugin, provides insert mode auto-completion for quotes, parens,
  "" brackets, etc.
  Plug 'raimondi/delimitmate'

  "" https://github.com/matze/vim-move
  "" Plugin to move lines and selections up and down
  " Plug 'matze/vim-move'

  "" https://github.com/SirVer/ultisnips
  "" UltiSnips - The ultimate snippet solution for Vim
  " Plug 'SirVer/ultisnips'

  "" https://github.com/bling/vim-airline
  "" lean & mean status/tabline for vim that's light as air
  Plug 'bling/vim-airline'

  "" https://github.com/bronson/vim-visual-star-search
  "" Start a * or # search from a visual block
  " Plug 'bronson/vim-visual-star-search'

  "" https://github.com/ervandew/supertab
  "" Perform all your vim insert mode completions with Tab
  " Plug 'ervandew/supertab'

  "" https://github.com/fatih/vim-go
  "" Go development plugin for Vim
  Plug 'fatih/vim-go'

  "" https://github.com/godlygeek/tabular
  "" Vim script for text filtering and alignment
  Plug 'godlygeek/tabular'

  "" https://github.com/bling/vim-bufferline
  "" Super simple vim plugin to show the list of buffers in the command bar
  " Plug 'bling/vim-bufferline'

  "" https://github.com/honza/vim-snippets
  "" vim-snipmate default snippets (Previously snipmate-snippets)
  " Plug 'honza/vim-snippets'

  "" https://github.com/kien/ctrlp.vim
  "" Fuzzy file, buffer, mru, tag, etc finder
  "" Plug 'kien/ctrlp.vim'

  "" https://github.com/majutsushi/tagbar
  "" Vim plugin that displays tags in a window, ordered by scope
  Plug 'majutsushi/tagbar'

  "" https://github.com/rking/ag.vim
  "" OR https://github.com/mileszs/ack.vim
  "" Vim plugin for the_silver_searcher, 'ag', a replacement for the Perl
  "" module / CLI script 'ack'
  Plug 'rking/ag.vim'

  "" https://github.com/scrooloose/nerdtree
  "" A tree explorer plugin for vim
  Plug 'scrooloose/nerdtree'

  "" https://github.com/jistr/vim-nerdtree-tabs
  "" NERDTree and tabs together in Vim, painlessly
  Plug 'jistr/vim-nerdtree-tabs'

  "" https://github.com/scrooloose/syntastic
  "" Syntax checking hacks for vim
  " Plug 'scrooloose/syntastic'

  "" https://github.com/benekastah/neomake
  "" A plugin for asynchronous :make using Neovim's job-control functionality
  Plug 'benekastah/neomake'

  "" https://github.com/terryma/vim-multiple-cursors
  "" True Sublime Text style multiple selections for Vim
  Plug 'terryma/vim-multiple-cursors'

  "" https://github.com/tpope/vim-commentary
  "" commentary.vim: comment stuff out
  Plug 'tpope/vim-commentary'

  "" https://github.com/tpope/vim-endwise
  "" wisely add 'end' in ruby, endfunction/endif/more in vim script, etc
  Plug 'tpope/vim-endwise'

  "" https://github.com/terryma/vim-expand-region
  "" visually select increasingly larger regions of text using the same key
  Plug 'terryma/vim-expand-region'

  "" https://github.com/tpope/vim-fugitive
  "" fugitive.vim: a Git wrapper so awesome, it should be illegal
  Plug 'tpope/vim-fugitive'

  "" https://github.com/airblade/vim-gitgutter
  "" A Vim plugin which shows a git diff in the gutter (sign column) and
  "" stages/reverts hunks.
  Plug 'airblade/vim-gitgutter'

  "" https://github.com/tpope/vim-rails
  "" rails.vim: Ruby on Rails power tools
  " Plug 'tpope/vim-rails'

  "" https://github.com/tpope/vim-dispatch
  "" dispatch.vim: asynchronous build and test dispatcher
  " Plug 'tpope/vim-dispatch'

   "" https://github.com/mattn/emmet-vim
   "" the essential toolkit for web-developers
   " Plug 'mattn/emmet-vim'

  "" http://github.com/bronson/vim-trailing-whitespace
  "" Highlights trailing whitespace in red and :FixWhitespace to fix it.
  Plug 'bronson/vim-trailing-whitespace'

  "" https://github.com/tpope/vim-surround
  "" surround.vim: quoting/parenthesizing made simple
  Plug 'tpope/vim-surround'

  "" https://github.com/idanarye/vim-merginal
  "" Fugitive extension to manage and merge Git branches
  " Plug 'idanarye/vim-merginal'

  "" https://github.com/gregsexton/gitv
  "" gitk for Vim
  " Plug 'gregsexton/gitv'

  "" https://github.com/vim-ruby/vim-ruby
  "" Vim/Ruby Configuration Files
  Plug 'vim-ruby/vim-ruby'

  "" https://github.com/vim-scripts/zoom.vim
  "" control gui font size with '+' or '-' keys
  " Plug 'vim-scripts/ZoomWin'

  "" https://github.com/mhinz/vim-startify
  "" A fancy start screen for Vim
  Plug 'mhinz/vim-startify'

  "" https://github.com/myusuf3/numbers.vim
  "" numbers.vim is a vim plugin for better line numbers
  Plug 'myusuf3/numbers.vim'

  "" https://github.com/kassio/neoterm
  "" Wrapper of some neovim's :terminal functions
  " Plug 'kassio/neoterm'

  "" https://github.com/junegunn/fzf
  "" A command-line fuzzy finder written in Go
  "" Plugin outside ~/.vim/plugged with post-update hook
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

  "" https://github.com/junegunn/fzf.vim
  "" Things you can do with fzf and Vim.
  Plug 'junegunn/fzf.vim'

  "" https://github.com/tpope/vim-markdown
  "" Vim Markdown runtime files
  " Plug 'tpope/vim-markdown'

  "" https://github.com/easymotion/vim-easymotion
  "" Vim motions on speed!
  " Plug 'easymotion/vim-easymotion'

  "" https://github.com/plasticboy/vim-markdown
  "" Markdown Vim Mode
  Plug 'plasticboy/vim-markdown'

  "" https://github.com/Valloric/YouCompleteMe
  "" A code-completion engine for Vim
  " Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
  " Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --clang-completer' }
  " Plug 'Valloric/YouCompleteMe'

  "" https://github.com/shougo/vimproc.vim
  "" Interactive command execution in Vim.
  Plug 'shougo/vimproc.vim'

  "" https://github.com/Shougo/deoplete.nvim
  "" Dark powered asynchronous completion framework for neovim
  "" Requires Python3 : 'pip3 install neovim'
  "" Plug 'shougo/deoplete.nvim'
  function! DoRemote(arg)
    UpdateRemotePlugins
  endfunction
  Plug 'shougo/deoplete.nvim', { 'do': function('DoRemote') }

  "" https://github.com/zchee/deoplete-go
  "" deoplete.nvim source for Go
  Plug 'zchee/deoplete-go', { 'do': 'make' }

  "" https://github.com/tpope/vim-repeat
  "" repeat.vim: enable repeating supported plugin maps with '.'
  " Plug 'tpope/vim-repeat'

  "" https://github.com/eagletmt/ghcmod-vim
  "" Happy Haskell programming on Vim, powered by ghc-mod
  Plug 'eagletmt/ghcmod-vim'

  "" Colors

  "" https://github.com/altercation/vim-colors-solarized
  "" precision colorscheme for the vim text editor
  " Plug 'altercation/vim-colors-solarized'

  "" https://github.com/w0ng/vim-hybrid
  "" A dark colour scheme for Vim & gVim
  Plug 'w0ng/vim-hybrid'

  "" https://github.com/zenorocha/dracula-theme
  "" A dark theme for Atom, Alfred, Chrome DevTools, iTerm, Sublime Text,
  "" Textmate, Terminal.app, Vim, Xcode, Zsh
  "" Plug 'zenorocha/dracula-theme'

  "" https://github.com/sickill/vim-monokai
  "" Monokai color scheme for Vim converted with coloration.ku1ik.com
  " Plug 'sickill/vim-monokai'

  "" https://github.com/twerth/ir_black
  "" The original IR_Black color scheme for vim
  " Plug 'twerth/ir_black'

  "" https://github.com/morhetz/gruvbox
  "" Retro groove color scheme for Vim
  "" Plug 'morhetz/gruvbox'
call plug#end()

"" vim-plug it automatically generates help tags for all of your plugins
"" whenever you run PlugInstall or PlugUpdate.
"" But you can regenerate help tags only with plug#helptags() function.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Theme selection
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:hybrid_use_Xresources = 1
set background=dark
" let g:solarized_visibility = 'high'
" let g:solarized_contrast = 'high'
" colorscheme solarized
colorscheme hybrid

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Windows rotations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" To change two vertically split windows to horizonally split
"" Ctrl-w t Ctrl-w K
"
"" Horizontally to vertically:
"" Ctrl-w t Ctrl-w H

"" Ctrl-w t makes the first (topleft) window current Ctrl-w K moves the
"" current window to full-width at the very top Ctrl-w H moves the current
"" window to full-height at far left

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Startup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" For multi-pane on startup: |   wincmd w
autocmd VimEnter *
      \   if !argc()
      \ |   Startify
      \ | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Startify configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:startify_session_dir = '~/.vim/session'
let g:startify_list_order = ['files', 'dir', 'bookmarks', 'sessions']
let g:startify_bookmarks = [
   \  '~/Workspaces',
   \  '~/Workspaces/go.sources/src/github.com/zeroed/',
   \  '~/Workspaces/gildsource',
   \  '~/Downloads'
   \  ]

let g:startify_list_order = [
  \ ['   Recently used files'],
  \ 'files',
  \ ['   Recently used files in the current directory:'],
  \ 'dir',
  \ ['   Sessions:'],
  \ 'sessions',
  \ ['   Bookmarks:'],
  \ 'bookmarks',
  \ ]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => NerdTree configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" If set to 1 then a double click on a node is required to open it.
"" If set to 2 then a single click will open directory nodes, while a double
"" click will still be required for file nodes.
"" If set to 3 then a single click will open any node.
let NERDTreeMouseMode=2

map - :NERDTreeTabsToggle<CR>

let g:nerdtree_tabs_open_on_console_startup=0
let g:nerdtree_tabs_focus_on_files=1
let g:nerdtree_tabs_startup_cd=0

"" open NERDTree when vim starts up if no files were specified
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

let NERDTreeIgnore=['\.swp$', '\.DS_Store']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Startify configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:startify_change_to_dir = 0
autocmd User Startified setlocal buftype=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" Use spaces instead of tabs
set expandtab

"" Be smart when using tabs ;)
set smarttab

"" An autoindent (with <<) is 2 spaces
set shiftwidth=2

"" A tab is 2 spaces
set tabstop=2

"" Set Linebreak on 500 characters
set linebreak

"" Set textwidth
set textwidth=72

"" Set Auto indent
set autoindent

"" Set Smart indent
set smartindent

"" Set Wrap
set wrap

"" Paste toggle
"" http://vim.wikia.com/wiki/VimTip906
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Rotate windows
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" To change two vertically split windows to horizonally split
"" Ctrl-w t Ctrl-w K
""
"" Horizontally to vertically:
"" Ctrl-w t Ctrl-w H
""
"" Explanations
"" Ctrl-w t makes the first (topleft) window current Ctrl-w K moves the
"" current window to full-width at the very top Ctrl-w H moves the current
"" window to full-height at far left

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Show invisible characterst
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
"" Show all tabs:
"" /\t
"
"" Show trailing whitespace:
"" /\s\+$
"
"" Show trailing whitespace only after some text (ignores blank lines):
"" /\S\zs\s\+$
"
"" Show spaces before a tab:
"" / \+\ze\t

"" Show invisible characters
"" In Vim, 'list' is a boolean option that defaults to off. If 'list' is
"" on, whitespace characters are made visible. The 'listchars' option can
"" be used to customize the way whitespace characters are shown. The
"" default displays "^I" for each tab, and "$" at each EOL (end of line, so
"" trailing whitespace can be seen). :help 'list'
set list

"" Reset the listchars
set listchars=""

"" A tab should display as "  "
set listchars=tab:\ \ ,trail:.
" set listchars=tab:\|\<Space>

"' Show trailing spaces as dots
set listchars+=trail:.

"" The character to show in the last column when wrap is off and the line
"" continues beyond the right of the screen
set listchars+=extends:>

"" The character to show in the first column when wrap is off and the line
"" continues beyond the left of the screen
set listchars+=precedes:<

"" Backspace through everything in insert mode
set backspace=indent,eol,start

"" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

"" Use the same symbols as TextMate for tabstops and EOLs
" set listchars=tab:▸\ ,eol:¬

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Dispatch configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" nnoremap <F9> :Dispatch<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Expand Region configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" Hit v to select one character
"" Hit vagain to expand selection to word
"" Hit v again to expand to paragraph
"" ...
"" Hit <C-v> go back to previous selection if I went too far
"" It seems like vvv is slower than vp but in practice I don’t need to
"" think beforehand what to select, and what key combination to use.
""
"" This way v replaces viw, vaw, vi", va", vi(, va(, vi[, va[, vi{, va{,
"" vip, vap, vit, vat, ... you get the idea.<F37>

" vmap v <Plug>(expand_region_expand)
" vmap <C-v> <Plug>(expand_region_shrink)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Netrw configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" In Vim you can edit directories, but sometimes it is more convenient to have
"" the names of all files in the complete subtree listed in one buffer. The
"" netrw plugin which creates the directory listing can be tweaked to show a
"" tree view, by using the g:netrw_liststyle variable in your .vimrc or from
"" the command-line before invoking the directory explorer:

let g:netrw_liststyle=3

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Reflow configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" The gq command takes comments and indentation into account. I normally
"" use V to visually select the lines (with k and j) and then press gq.
"" The textwidth option is used to format the lines at the appropriate
"" length.  See :help gq for more information.

function! s:setupWrapping()
  set wrap
  set wrapmargin=2
  set textwidth=80
endfunction

"" Alternatively, format options can be set so that a paragraph is
"" reflowed automatically, after each change. :help auto-format An
"" example setting for formatoptions (fo) is:

" :setl fo=aw2tq

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Numbers configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set number
" set relativenumber
" nnoremap <F3> :NumbersToggle<CR>
" nnoremap <F4> :NumbersOnOff<CR>

function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

set ruler

"" show the cursor position all the time
" :set rulerformat=%-14.(%l,%c%V%)\ %P

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Vim-Move Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" Using the move.vim plugin...
"" <A-k>   Move current line/selection up
"" <A-j>   Move current line/selection down

"" http://vim.wikia.com/wiki/Moving_lines_up_or_down
"" Adapted to the OSX Alt key, this is the solution:

"" nnoremap <A-j> :m .+1<CR>==
"" nnoremap <A-k> :m .-2<CR>==
"" inoremap <A-j> <Esc>:m .+1<CR>==gi
"" inoremap <A-k> <Esc>:m .-2<CR>==gi
"" vnoremap <A-j> :m '>+1<CR>gv=gv
"" vnoremap <A-k> :m '<-2<CR>gv=gv

nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
inoremap ∆ <Esc>:m .+1<CR>==gi
inoremap ˚ <Esc>:m .-2<CR>==gi
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Stuff Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" highlight the current line in every window and update the highlight as the
"" cursor moves.
set cursorline

"" When you set showcmd in your vimrc, the bottom line in your editor will show
"" you information about the current command going on.
set showcmd

" avoids munging PATH under zsh
set shell=bash

" default shell syntax
let g:is_bash=1

" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

"" Lamer mouse things
"" mouse=a prevents the ability of copying and pasting out of vim with
"" readable characters.
"" In this way numbers won't be selected.
"" Change mouse=a to mouse=r and that should fix your issue with that.
set mouse=a

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Multiple-cursor configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" Default mappings
" let g:multi_cursor_next_key='<C-n>'
" let g:multi_cursor_prev_key='<C-p>'
" let g:multi_cursor_skip_key='<C-x>'
" let g:multi_cursor_quit_key='<Esc>'

"" Map start key separately from next key
" let g:multi_cursor_start_key='<F6>'

"" Default highlighting (see help :highlight and help :highlight-link)
" highlight multiple_cursors_cursor term=reverse cterm=reverse gui=reverse
" highlight link multiple_cursors_visual Visual

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Autosave configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" :au FocusLost * :wa

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Searching configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" highlight matches
set hlsearch
"" incremental searching
set incsearch
"" searches are case insensitive...
set ignorecase
"" ... unless they contain at least one capital letter
set smartcase

"" wildmode
set wildmenu
set wildmode=longest:full,full

"" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Autocmd configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" You can specify commands to be executed automatically when reading or writing
"" a file, when entering or leaving a buffer or window, and when exiting Vim.
"" For example, you can create an autocommand to set the 'cindent' option for
"" files matching *.c.  You can also use autocommands to implement advanced
"" features, such as editing compressed files (see |gzip-example|).  The usual
"" place to put autocommands is in your .vimrc or .exrc file.

if has("autocmd")
  "" In Makefiles, use real tabs, not tabs expanded to spaces
  autocmd FileType make set noexpandtab

  "" Make sure all markdown files have the correct filetype set and setup wrapping
  autocmd BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown | call s:setupWrapping()

  "" Treat JSON files like JavaScript
  autocmd BufNewFile,BufRead *.json set ft=javascript

  "" Vim file
  " autocmd FileType vim setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2

  "" make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
  autocmd FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

  "" Remember last location in file, but not for commit messages.
  "" see :help last-position-jump
  autocmd BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif

  "" Mark Jekyll YAML frontmatter as comment
  autocmd BufNewFile,BufRead *.{md,markdown,html,xml} sy match Comment /\%^---\_.\{-}---$/

  "" Remove whitespaces on save
  autocmd BufWrite * FixWhitespace
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => FZF configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

:nmap <C-p> :Files<CR>
:nmap <C-l> :Buffers<CR>
" :nmap <C-i> :Lines<CR>

" fzf --color fg:252,bg:233,hl:67,fg+:252,bg+:235,hl+:81
" fzf --color info:144,prompt:161,spinner:135,pointer:135,marker:118

"" Respecting .gitignore, .hgignore, and svn:ignore
"" Let's do the job to AG
"" # Feed the output of ag into fzf
"" ag -l -g '' | fzf
""
"" # Setting ag as the default source for fzf
"" export FZF_DEFAULT_COMMAND='ag -l -g ""'
""
"" # Now fzf (w/o pipe) will use ag instead of find
"" fzf
""
"" # To apply the command to CTRL-T as well
"" export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

"" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

"" Default fzf layout
"" - down / up / left / right
"" - window (nvim only)
let g:fzf_layout = { 'down': '~40%' }

"" Advanced customization using autoload functions
" autocmd VimEnter * command! Colors
"   \ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'})

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => GOLANG configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:go_fmt_command = "goimports"

if has("autocmd")
  autocmd BufRead,BufNewFile *.go set filetype=go

  autocmd FileType go nmap <Leader>s <Plug>(go-implements)
  autocmd FileType go nmap <Leader>i <Plug>(go-info)

  autocmd FileType go nmap <Leader>gd <Plug>(go-doc)
  autocmd FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
  autocmd FileType go nmap <Leader>gb <Plug>(go-doc-browser)

  " autocmd FileType go nmap <leader>r <Plug>(go-run)
  autocmd FileType go nmap <leader>gb <Plug>(go-build)
  autocmd FileType go nmap <leader>gt <Plug>(go-test)
  autocmd FileType go nmap <leader>c <Plug>(go-coverage)

  autocmd FileType go nmap <Leader>ds <Plug>(go-def-split)
  autocmd FileType go nmap <Leader>dv <Plug>(go-def-vertical)
  " autocmd FileType go nmap <Leader>dt <Plug>(go-def-tab)
  autocmd FileType go nmap gd <Plug>(go-def-tab)

  autocmd FileType go setlocal commentstring=//\ %s
endif

"" I don't like the preview pane
set completeopt-=preview

let g:go_highlight_build_constraints = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => UltiSnips and SuperTab configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" autocmd FileType * call UltiSnips#FileTypeChanged()

"" Make YCM compatible with UltiSnips (using supertab)
" let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
" let g:SuperTabDefaultCompletionType = '<C-n>'

"" better key bindings for UltiSnipsExpandTrigger
" let g:UltiSnipsExpandTrigger = '<tab>'
" let g:UltiSnipsJumpForwardTrigger = '<tab>'
" let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Commentary configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vmap \\ gc
" nmap \\ gcc

if has("autocmd")
    augroup plugin_commentary
        autocmd!
        autocmd FileType asm setlocal commentstring=;\ %s
        autocmd FileType *conf-d setlocal commentstring=#\ %s
        autocmd FileType *config setlocal commentstring=#\ %s
        autocmd FileType c,cpp setlocal commentstring=//\ %s
        autocmd BufEnter *.conf setlocal commentstring=#\ %s
        autocmd FileType robot setlocal commentstring=Comment\ \ \ \ %s
        autocmd FileType cfg setlocal commentstring=#\ %s
        autocmd FileType fstab setlocal commentstring=#\ %s
        autocmd FileType gentoo-init-d,gentoo-package-use,gentoo-package-keywords setlocal commentstring=#\ %s
        autocmd FileType htmldjango setlocal commentstring={#\ %s\ #}
        autocmd FileType clojurescript setlocal commentstring=;\ %s
        autocmd FileType puppet setlocal commentstring=#\ %s
        autocmd FileType fish setlocal commentstring=#\ %s
        autocmd FileType tmux setlocal commentstring=#\ %s
        autocmd FileType gitconfig setlocal commentstring=#\ %s
    augroup END
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Alternate file helper
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" Ctrl-^ is very handy command in normal mode. Ctrl-^
"" switches to 'alternate file'. When there is no 'alternate file',
"" I wanted Ctrl-^ to jump to next file in the list.
"" Insert following commands into your vimrc, then
"" Ctrl-^ will be enhanced so that when there is no alternate file
"" but there is next file, it will jump to the next file.
"" My remapping of <C-^>. If there is no alternate file, then switch to next
"" file.

" function! MySwitch()
"   if expand('#')=="" | silent! next
"   else
"     exe 'normal! \<c-^>'
"   endif
" endfu
" map <C-^> :call MySwitch()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => FZF configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" nmap F :Ag<cr>
map <leader>f :FZF<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => CtrlP configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" map <leader>b :CtrlPBuffer<cr>
"" map <leader>b :CtrlPBuffer ~/Workspaces<cr>
" let g:ctrlp_map = '<c-p>'
" let g:ctrlp_cmd = 'CtrlP'
"
" let g:ctrlp_custom_ignore = {
"   \ 'dir':  '\.git$\|\.hg$\|\.svn$\$|Applications/.*|Library/.*',
"   \ 'file': '\v\.(exe|so|dll)$',
"   \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
"   \ }
" let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
" if executable('ag')
"   let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
" endif
" let g:ctrlp_clear_cache_on_exit = 0
" let g:ctrlp_working_path_mode = 'ra'

"" When invoked, unless a starting directory is specified, CtrlP will set its
"" local working directory according to this variable:
""  - 'c' - the directory of the current file.
""  - 'r' - the nearest ancestor that contains one of these directories or
""          files: .git .hg .svn .bzr _darcs
""  - 'a' - like c, but only if the current working directory outside of
""          CtrlP is not a direct ancestor of the directory of the current
""          file.
""  - 0 or '' (empty string) - disable this feature.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Ag configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" You can specify a custom ag name and path
" let g:agprg="<custom-ag-path-goes-here> --vimgrep"

"" You can configure ag.vim to always start searching from your project
"" root instead of the cwd
let g:ag_working_path_mode="r"

"" use ag for recursive searching
" nnoremap <leader>* :call ag#Ag('grep',g'--literal ' .  shellescape(expand("<cword>")))<CR>
" vnoremap <leader>* :<C-u>call VisualStarSearchSet('/', 'raw')<CR>:call ag#Ag('grep', '--literal ' . shellescape(@/))<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Neomake configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd! BufWritePost * Neomake
let g:neomake_open_list = 0
"" *g:neomake_open_list*
"" This setting will open the |loclist| or |quickfix| list (depending on whether
"" it is operating on a file) when adding entries. A value of 2 will preserve the
"" cursor position when the |loclist| or |quickfix| window is opened. Defaults to 0.
"
"" *g:neomake_list_height*
"" The height of the |loclist| or |quickfix| list opened by neomake.
"" Defaults to 10.


" let g:neomake_warning_sign = {
"   \ 'text': 'W',
"   \ 'texthl': 'WarningMsg',
"   \ }

" let g:neomake_error_sign = {
"   \ 'text': 'E',
"   \ 'texthl': 'ErrorMsg',
"   \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Syntastic configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:syntastic_check_on_open=1
" let g:syntastic_check_on_wq=0
" let g:syntastic_error_symbol='✗'
" let g:syntastic_warning_symbol='⚠'
" let g:syntastic_always_populate_loc_list=1
" let g:syntastic_auto_loc_list=1

"" let g:syntastic_aggregate_errors=1
"" let g:syntastic_enable_ballons=has('ballon_eval')
"" let g:syntastic_auto_jump=1
"" let g:syntastic_loc_list_height=3
"" let g:syntastic_ignore_files = ['^/usr/', '*node_modules*',
""   '*vendor*', '*build*', '*LOCAL*', '*BASE', '*REMOTE*']
"" let g:syntastic_mode_map = { 'mode': 'active' }
"" let g:syntastic_javascript_checkers=['jshint', 'jscs']
"" let g:syntastic_json_checkers=['jsonlint', 'jsonval']
"" let g:syntastic_ruby_checkers=['rubocop','mri']
"" let g:syntastic_perl_checkers=['perl','perlcritic','podchecker']
"" let g:syntastic_python_checkers=['pylint','pep8','python']
"" let g:syntastic_cpp_checkers=['gcc','cppcheck','cpplint','ycm','clang_tidy','clang_check']
"" let g:syntastic_c_checkers=['gcc','make','cppcheck','clang_tidy','clang_check']
"" let g:syntastic_haml_checkers=['haml_lint', 'haml']
"" let g:syntastic_html_checkers=['jshint']
"" let g:syntastic_yaml_checkers=['jsyaml']
"" let g:syntastic_sh_checkers=['sh','shellcheck','checkbashisms']
"" let g:syntastic_vim_checkers=['vimlint']
"" let g:syntastic_enable_perl_checker=1
"" let g:syntastic_c_clang_tidy_sort=1
"" let g:syntastic_c_clang_check_sort=1
"" let g:syntastic_c_remove_include_errors=1
"" let g:syntastic_quiet_messages = { 'level': '[]', 'file': ['*_LOCAL_*', '*_BASE_*', '*_REMOTE_*']  }
"" let g:syntastic_stl_format = '[%E{E: %fe #%e}%B{, }%W{W: %fw #%w}]'
"" let g:syntastic_java_javac_options = '-g:none -source 8 -Xmaxerrs 5 -Xmaswarns 5'

"" set statusline+=%#warningmsg#
"" set statusline+=%{SyntasticStatuslineFlag()}
"" set statusline+=%*

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Insert filename configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" http://vim.wikia.com/wiki/Insert_current_filename
"" It inserts the current filename without the extension at the cursor position, when you are in insert mode.
" inoremap \fn <C-R>=expand("%:t:r")<CR>

"" To keep the extension use:
" inoremap \fn <C-R>=expand("%:t")<CR>

"" To insert the absolute path of the directory the file is in use:
" inoremap \fn <C-R>=expand("%:p:h")<CR>

"" To insert the relative path of the directory the file is in use:
" inoremap \fn <C-R>=expand("%:h")<CR>
" cnoremap %% <C-R>=expand('%:h').'/'<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Trailing whitespaces configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" Now provided by the plugin bronson/vim-trailing-whitespace, otherwise:
"" Strip trailing whitespace (,ss)
" function! StripWhitespace()
"   let save_cursor = getpos(".")
"   let old_query = getreg('/')
"   :%s/\s\+$//e
"   call setpos('.', save_cursor)
"   call setreg('/', old_query)
" endfunction

" noremap <leader>ss :call StripWhitespace()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Statusline configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" if has("statusline") && !&cp
"   set laststatus=2  " always show the status bar
"
"   " Start the status line
"   set statusline=%f\ %m\ %r
"
"   " Add fugitive
"   set statusline+=%{fugitive#statusline()}
"
"   " Finish the statusline
"   set statusline+=Line:%l/%L[%p%%]
"   set statusline+=Col:%v
"   set statusline+=Buf:#%n
"   set statusline+=[%b][0x%B]
" endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Airline configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:airline_powerline_fonts=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Testing Shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" map <Leader>TT :call neoterm#test#run('suite')<CR>
" map <Leader>T :call neoterm#test#run('file')<CR>
" map <Leader>t :call neoterm#test#run('current')<CR>

" map <leader>r :NERDTreeFind<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => TagBar configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <F8> :TagbarToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Deoplete configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set runtimepath+=/Users/edoardo/.nvim/plugged/deoplete.nvim/
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 'ignorecase'
inoremap <silent><expr> <Tab>
  \ pumvisible() ? "\<C-n>" :
  \ deoplete#mappings#manual_complete()
let g:deoplete#sources#go#align_class = 1
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#package_dot = 1
let g:deoplete#sources#go#gocode_binary = '/Users/edoardo/Workspaces/go.sources/bin/gocode'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => YouCompleteme configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" function! BuildYCM(info)
""    "  info is a dictionary with 3 fields
""    "  - name:   name of the plugin
""    "  - status: 'installed', 'updated', or 'unchanged'
""    "  - force:  set on PlugInstall! or PlugUpdate!
""   if a:info.status == 'installed' || a:info.force
""     !./install.sh
""   endif
"" endfunction

" let g:ycm_min_num_of_chars_for_completion = 2
" let g:ycm_min_num_identifier_candidate_chars = 0
" let g:ycm_auto_trigger = 1
" let g:ycm_filetype_whitelist = { '*': 1 }
" let g:ycm_filetype_blacklist = {
"       \ 'tagbar' : 1,
"       \ 'qf' : 1,
"       \ 'notes' : 1,
"       \ 'markdown' : 1,
"       \ 'unite' : 1,
"       \ 'text' : 1,
"       \ 'vimwiki' : 1,
"       \ 'pandoc' : 1,
"       \ 'infolog' : 1,
"       \ 'mail' : 1
"       \}
" let g:ycm_filetype_specific_completion_to_disable = {
"       \ 'gitcommit': 1
"       \}
" let g:ycm_show_diagnostics_ui = 1
" let g:ycm_error_symbol='✗'
" let g:ycm_warning_symbol='⚠'
" let g:ycm_error_symbol = '>>'
" let g:ycm_warning_symbol = '>>'
" let g:ycm_enable_diagnostic_highlighting = 1
" let g:ycm_enable_diagnostic_signs = 1
" let g:ycm_echo_current_diagnostic = 1
" let g:ycm_always_populate_location_list = 0
" let g:ycm_open_loclist_on_ycm_diags = 1
" let g:ycm_allow_changing_updatetime = 1
" let g:ycm_complete_in_comments = 0
" let g:ycm_collect_identifiers_from_comments_and_strings = 0
" let g:ycm_collect_identifiers_from_tags_files = 0
" let g:ycm_seed_identifiers_with_syntax = 0
" let g:ycm_extra_conf_vim_data = []
" let g:ycm_path_to_python_interpreter = ''
" let g:ycm_server_use_vim_stdout = 0
" let g:ycm_server_keep_logfiles = 0
" let g:ycm_server_log_level = 'info'
" let g:ycm_autoclose_preview_window_after_completion = 0
" let g:ycm_autoclose_preview_window_after_insertion = 0
" let g:ycm_max_diagnostics_to_display = 30
" let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']
" let g:ycm_key_invoke_completion = '<C-Space>'
" let g:ycm_key_detailed_diagnostics = '<leader>d'
" let g:ycm_global_ycm_extra_conf = ''
" let g:ycm_confirm_extra_conf = 1
" let g:ycm_use_ultisnips_completer = 1
" let g:ycm_goto_buffer_command = 'same-buffer'
" let g:ycm_disable_for_files_larger_than_kb = 1000

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => GoTag configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" https://github.com/jstemmer/gotags
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => BufferClose helper
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" Delete buffer while keeping window layout (don't close buffer's windows).
"" Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
" if v:version < 700 || exists('loaded_bclose') || &cp
"   finish
" endif
" let loaded_bclose = 1
" if !exists('bclose_multiple')
"   let bclose_multiple = 1
" endif

" " Display an error message.
" function! s:Warn(msg)
"   echohl ErrorMsg
"   echomsg a:msg
"   echohl NONE
" endfunction

"" Command ':Bclose' executes ':bd' to delete buffer in current window.
"" The window will show the alternate buffer (Ctrl-^) if it exists,
"" or the previous buffer (:bp), or a blank buffer if no previous.
"" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
"" An optional argument can specify which buffer to close (name or number).
" function! s:Bclose(bang, buffer)
"   if empty(a:buffer)
"     let btarget = bufnr('%')
"   elseif a:buffer =~ '^\d\+$'
"     let btarget = bufnr(str2nr(a:buffer))
"   else
"     let btarget = bufnr(a:buffer)
"   endif
"   if btarget < 0
"     call s:Warn('No matching buffer for '.a:buffer)
"     return
"   endif
"   if empty(a:bang) && getbufvar(btarget, '&modified')
"     call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
"     return
"   endif
"   " Numbers of windows that view target buffer which we will delete.
"   let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
"   if !g:bclose_multiple && len(wnums) > 1
"     call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
"     return
"   endif
"   let wcurrent = winnr()
"   for w in wnums
"     execute w.'wincmd w'
"     let prevbuf = bufnr('#')
"     if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
"       buffer #
"     else
"       bprevious
"     endif
"     if btarget == bufnr('%')
"       " Numbers of listed buffers which are not the target to be deleted.
"       let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
"       " Listed, not target, and not displayed.
"       let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
"       " Take the first buffer, if any (could be more intelligent).
"       let bjump = (bhidden + blisted + [-1])[0]
"       if bjump > 0
"         execute 'buffer '.bjump
"       else
"         execute 'enew'.a:bang
"       endif
"     endif
"   endfor
"   execute 'bdelete'.a:bang.' '.btarget
"   execute wcurrent.'wincmd w'
" endfunction
" command! -bang -complete=buffer -nargs=? Bclose call s:Bclose('<bang>', '<args>')
" nnoremap <silent> <Leader>bd :Bclose<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => End File
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ClearRegisters()
    let regs='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-="*+'
    let i=0
    while (i<strlen(regs))
        exec 'let @'.regs[i].'=""'
        let i=i+1
    endwhile
endfunction
command! ClearRegisters call ClearRegisters()

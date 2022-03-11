" Zal's vim config :3

" load plugins, using vimplug
call plug#begin('~/.local/share/nvim/plugged')
Plug 'gentoo/gentoo-syntax'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-startify'
Plug 'lervag/vimtex'
call plug#end() 

syntax enable
filetype plugin indent on

" don't care about vi compatibility
set nocompatible

" tab creates 4 spaces, tabstop is 4 spaces wide
set ts=4 sw=4 expandtab

" indentation stuff
set autoindent
set backspace=indent,eol,start

" line numbers
set number

" disable line wrap
set nowrap
set tw=999

" enable mouse-terminal interaction
set mouse=a
if !has('nvim')
    " only needed for classic vim. neovim does this automatically
    set ttymouse=sgr
endif

" key timeout
set ttimeout
set ttimeoutlen=50 

" always display a status line even if there is only one window
set laststatus=2

" allow modified buffers to be hidden
set hidden

" default spellcheck language
set spelllang=en

" don't create swap files. they tend to hang vim when the disk has high load,
"  and my compulsive :w habit makes them superflous, anyway. also, when was the
"  last time you saw vim crash?
set noswapfile

" use system clipboard transparently when yanking
set clipboard=unnamed

" smart case search (only use case sensitive search if query contains uppercase)
set ignorecase
set smartcase

" use space key as leader
nnoremap <SPACE> <Nop>
let mapleader = " "
let g:mapleader = " "

" buffer navigation commands
nnoremap <leader>h :bprevious<CR>
nnoremap <leader>l :bnext<CR>
nnoremap <leader>d :bd!<CR>
nnoremap <leader>n :enew<CR>
nnoremap <leader>q :q<CR>

" faster compulsive saving
nnoremap <leader>w :w<CR>

" session shortcuts
nnoremap <F2> :mksession! ~/.vimsession<CR>
nnoremap <F3> :source ~/.vimsession<CR>

" make arrow keys navigate splits rather than the cursor
noremap <Up> <C-w>k
noremap <Down> <C-w>j
noremap <Left> <C-w>h
noremap <Right> <C-w>l
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" replace currently selected text with default register
" without yanking it
vnoremap <leader>p "_dP

" nerdtree stuff
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
nnoremap <leader>t :NERDTreeToggle<CR>

" fugitive via leader
nnoremap <leader>g :G<CR>

" terminal emulator stuff
tnoremap <Esc> <C-\><C-n>

" don't need indentation with motions
nnoremap < <<
nnoremap > >>

" ctrlp config
" use The Silver Searcher for ctrlp
set grepprg=ag\ --nogroup\ --nocolor
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_use_caching = 0

" vimtex
let g:tex_flavor = 'latex'

" highlight matching parens by underlining them
highlight MatchParen term=underline cterm=underline gui=underline ctermbg=NONE

" ===== visual stuff =====
" airline config
let g:airline_powerline_fonts = 1
let g:airline_theme = 'simple'
let g:airline_highlighting_cache = 1
let g:airline_extensions = ['branch', 'tabline']
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamemod = ':t'

" cursor shapes (beam cursor in insert modes. very fancy :3)
"  nvim does this automatically
if !has('nvim')
    let &t_SI = "\<Esc>[5 q"
    let &t_EI = "\<Esc>[2 q"
endif

" use proper box-drawing character for vertical splits
set fillchars+=vert:┃

" Zal's nvim config :3

" load plugins, using vimplug
call plug#begin('~/.local/share/nvim/plugged')
Plug 'gentoo/gentoo-syntax'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-startify'
Plug 'lervag/vimtex'
Plug 'ledger/vim-ledger'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
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

" sane textwidth of 100 chars. highlight the column *after* that limit
set tw=100
set colorcolumn=+1

" enable mouse-terminal interaction
set mouse=a

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

" startify session restore
autocmd! VimLeave * SSave! Previous

" make arrow keys navigate splits rather than the cursor
noremap <Up> <C-w>k
noremap <Down> <C-w>j
noremap <Left> <C-w>h
noremap <Right> <C-w>l
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

" replace currently selected text with default register
" without yanking it
vnoremap <leader>p "_dP

" nvimtree stuff
nnoremap <leader>t :NvimTreeToggle<CR>

" fugitive via leader
nnoremap <leader>g :G<CR>

" terminal emulator stuff
tnoremap <Esc> <C-\><C-n>

" don't need indentation with motions
nnoremap < <<
nnoremap > >>

" vimtex
let g:tex_flavor = 'latex'

lua require("nvim-tree").setup()

" ===== visual stuff =====
" airline config
let g:airline_powerline_fonts = 1
let g:airline_theme = 'simple'
let g:airline_highlighting_cache = 1
let g:airline_extensions = ['branch', 'tabline']
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamemod = ':t'

" use proper box-drawing character for vertical splits
set fillchars+=vert:┃

" highlight matching parens by underlining them
highlight MatchParen term=underline cterm=underline gui=underline ctermbg=NONE

" highlight trailing whitespace
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$/


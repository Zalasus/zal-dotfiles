" Zal's vim config
"  Some basic stuff that should work on vim and nvim is done here in vimscript. All the advanced,
"  productive things that requires a recent nvim and plugins happen in the lua config invoked below.

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

" always display a status line even if there is only one window
set laststatus=2

" allow modified buffers to be hidden
set hidden

" default spellcheck language
set spelllang=en

" use system clipboard transparently when yanking
set clipboard=unnamed,unnamedplus

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

" don't need indentation with motions
nnoremap < <<
nnoremap > >>

" use proper box-drawing character for vertical splits
set fillchars+=vert:│

" enable syntax higlighting
syntax enable

" highlight matching parens by underlining them
highlight MatchParen term=underline cterm=underline gui=underline ctermbg=NONE

" always show signcolumn, but don't color it
set signcolumn=yes
highlight SignColumn ctermbg=none guibg=none

" enable filetype detection, using type-specific plugins and indent files when available
filetype plugin indent on

if has('nvim')
    luafile $ZAL_DOTFILES/vim/zal-neovim.lua
endif


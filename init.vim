call plug#begin()

Plug 'nvim-lualine/lualine.nvim'
Plug 'morhetz/gruvbox'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-scripts/AutoComplPop'
Plug 'ThePrimeagen/vim-be-good'
"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

inoremap { {}<Esc>ha
inoremap ( ()<Esc>ha
inoremap [ []<Esc>ha
inoremap " ""<Esc>ha
inoremap ' ''<Esc>ha
inoremap ` ``<Esc>ha

set clipboard+=unnamedplus
aunmenu PopUp.How-to\ disable\ mouse
aunmenu PopUp.-1-

:colorscheme gruvbox
let g:gruvbox_contrast_dark='hard'

set so=7
set complete+=kspell
set completeopt+=menuone,longest
set completeopt+=noinsert
let g:mucomplete#completion_delay = 1

set number relativenumber
autocmd InsertLeave * :set number relativenumber
autocmd InsertEnter * :set number norelativenumber

set smartcase
au InsertEnter * set noic 
au InsertLeave * set noic

set mouse=a
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set encoding=UTF-8
set background=dark
set noshowmode

au FocusLost * :w

lua << END

require('lualine').setup()
options = { theme = 'gruvbox' }

END


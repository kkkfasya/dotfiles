call plug#begin('~/AppData/Local/nvim/plugged')

Plug 'windwp/nvim-autopairs'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-scripts/AutoComplPop'

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

set complete+=kspell
set completeopt+=menuone,longest
set completeopt+=noinsert
let g:mucomplete#completion_delay = 1

set number relativenumber
set mouse=a
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set encoding=UTF-8
set background=dark




call plug#begin()

Plug 'nvim-lualine/lualine.nvim'
Plug 'morhetz/gruvbox'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-scripts/AutoComplPop'
Plug 'ThePrimeagen/vim-be-good'
Plug 'xiyaowong/transparent.nvim'
Plug 'fkys/timelapse.nvim' " my own plugin!!!
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

call plug#end()

let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-d>'
let g:VM_maps['Find Subword Under'] = '<C-d>'

nnoremap <silent> <C-Left> :vertical resize -3<CR>
nnoremap <silent> <C-Right> :vertical resize +3<CR>
nnoremap <silent> <C-Up> :resize -3<CR>
nnoremap <silent> <C-Down> :resize +3<CR>

inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

inoremap { {}<Esc>ha
inoremap ( ()<Esc>ha
inoremap [ []<Esc>ha
inoremap " ""<Esc>ha
inoremap ' ''<Esc>ha
inoremap ` ``<Esc>ha
inoremap */ /**/<Esc>hha

set clipboard+=unnamedplus
aunmenu PopUp.How-to\ disable\ mouse
aunmenu PopUp.-1-

colorscheme gruvbox
let g:gruvbox_contrast_dark='hard'

set so=7
set complete+=kspell
set completeopt+=menuone,longest
set completeopt+=noinsert

set number relativenumber
autocmd InsertLeave * :set number relativenumber
autocmd InsertEnter * :set number norelativenumber

set smartcase
au InsertEnter * set noic
au InsertLeave * set noic
au FocusLost * :w

set mouse=a
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set expandtab
set encoding=UTF-8
set background=dark
set noshowmode
set title
set noswapfile

lua << END

require('lualine').setup()
options = { theme = 'gruvbox' }

END

let mapleader = " "

set clipboard+=unnamedplus
aunmenu PopUp.How-to\ disable\ mouse
aunmenu PopUp.-1-

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

inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

nnoremap <Leader>p <Cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>
nnoremap <Leader>f <Cmd>lua require('vscode').action('workbench.view.search')<CR>
nnoremap <Leader>e <Cmd>lua require('vscode').action('workbench.view.explorer')<CR>

lua << END
END

" FIX: ctrl + shift + v not working

call plug#begin()

Plug 'vscode-neovim/vscode-multi-cursor.nvim'

call plug#end()

let mapleader = " "

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="CurSearch", timeout=100})
augroup END

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
nnoremap <Leader>bb <Cmd>lua require('vscode').action( 'workbench.action.navigateLast')<CR>

nnoremap E <Cmd>lua require('vscode').action('workbench.action.problems.focus')<CR>
nnoremap gp <Cmd>lua require('vscode').action( 'editor.action.peekDefinition')<CR>
nnoremap F <Cmd>lua require('vscode').action( 'editor.action.formatDocument')<CR>

lua << END

require('vscode-multi-cursor').setup()
vim.keymap.set({ "n", "x", "i" }, "<C-d>", function()
require("vscode-multi-cursor").addSelectionToNextFindMatch()
end)

END

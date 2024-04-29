call plug#begin()

Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'nvim-lualine/lualine.nvim'
" Plug 'morhetz/gruvbox'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'jiangmiao/auto-pairs'
Plug 'ThePrimeagen/vim-be-good'
Plug 'xiyaowong/transparent.nvim'
Plug 'fkys/timelapse.nvim' " my own plugin!!!
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' }
" or                                , { 'branch': '0.1.x' }
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-d>'
let g:VM_maps['Find Subword Under'] = '<C-d>'

nnoremap <silent> <C-Left> :vertical resize -3<CR>
nnoremap <silent> <C-Right> :vertical resize +3<CR>
nnoremap <silent> <C-Up> :resize -3<CR>
nnoremap <silent> <C-Down> :resize +3<CR>

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

" colorscheme gruvbox
" let g:gruvbox_contrast_dark='hard'

set so=7
" set complete+=kspell
" set completeopt+=menuone,longest
" set completeopt+=noinsert

set number relativenumber
autocmd InsertLeave * :set number relativenumber
autocmd InsertEnter * :set number norelativenumber

"au InsertEnter * set noic
"au InsertLeave * set noic
au FocusLost * :w

set undodir=~/.nvim_undodir
set undofile

set mouse=a
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set encoding=UTF-8
set background=dark
set noshowmode
set title
set noswapfile

let mapleader = " "

lua << END
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Others
require("bufferline").setup{}
require('lualine').setup{
  options = { theme = 'gruvbox' }
}

-- Mappings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-e>', ':NvimTreeOpen<CR>', {noremap = true})
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
-- vim.keymap.set('n', '<C-f>', builtin.live_grep, {})
vim.keymap.set('n', '<C-f>', function()
	builtin.grep_string({ search = vim.fn.input("grep > ") })
end)

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
vim.keymap.set('n', 'gr', builtin.lsp_references, {})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})


-- LSP
require("mason").setup()
require("mason-lspconfig").setup{
    ensure_installed = { "lua_ls", "clangd"},
}
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("lspconfig").lua_ls.setup{
  capabilities = capabilities
}
require("lspconfig").clangd.setup{
  capabilities = capabilities
}

require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- AutoComplete
local cmp = require('cmp')
  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
       completion = cmp.config.window.bordered(),
       documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
       { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    })
  })

  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

-- TS
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "lua" },
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- Colorscheme
require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = false,
  bold = false,
  italic = {
    strings = false,
    emphasis = false,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = false,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {
    ["@lsp.type.function"] = { fg = "#ff9900" },
    ["@lsp.type.method"] = { fg = "#ff9900" },
    ["@lsp.type.macro"] = { fg = "#fabd2f" }
    },
  dim_inactive = false,
  transparent_mode = false,
})
vim.cmd("colorscheme gruvbox")


END


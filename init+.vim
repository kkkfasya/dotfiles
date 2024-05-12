bufdo set expandtab sw=4 ts=4

call plug#begin()
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'folke/trouble.nvim'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'nvim-lualine/lualine.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'jiangmiao/auto-pairs'
Plug 'fkys/timelapse.nvim' " my own plugin!!!
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'akinsho/toggleterm.nvim'
Plug 'akinsho/bufferline.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' }

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'rmagatti/goto-preview'

call plug#end()

let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-d>'
let g:VM_maps['Find Subword Under'] = '<C-d>'

autocmd TermEnter term://*toggleterm#*
      \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>

nnoremap <silent> <C-Left> :vertical resize +3<CR>
nnoremap <silent> <C-Right> :vertical resize -3<CR>
nnoremap <silent> <C-Up> :resize -3<CR>
nnoremap <silent> <C-Down> :resize +3<CR>

inoremap { {}<Esc>ha
inoremap ( ()<Esc>ha
inoremap [ []<Esc>ha
inoremap " ""<Esc>ha
inoremap ' ''<Esc>ha
inoremap ` ``<Esc>ha
inoremap */ /**/<Esc>hha

nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

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
au FocusLost * silent! wall
au BufLeave * silent! wall
au BufWinEnter,WinEnter term://* startinsert
set undodir=~/.nvim_undodir
set undofile
set autowriteall

set expandtab sw=4 ts=4

set mouse=a
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

require('bufferline').setup{}
require('lualine').setup{
  options = { theme = 'gruvbox' }
}
require('goto-preview').setup{
  post_open_hook = function(buf, win)
    vim.keymap.set("n", "q", "<cmd>lua require('goto-preview').close_all_win()<CR>", {noremap=true})
  end
}


-- Mappings
local telescope = require('telescope.builtin')
local nvimtree = require("nvim-tree.api")

vim.keymap.set('n', '<C-e>', ':NvimTreeOpen<CR>', {noremap = true})
vim.keymap.set('n', '<C-p>', telescope.find_files, {})
-- vim.keymap.set('n', '<C-f>', telescope.live_grep, {})
vim.keymap.set('n', '<C-f>', function()
	telescope.grep_string({ search = vim.fn.input("grep > ") })
end)

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
vim.keymap.set('n', 'gr', telescope.lsp_references, {})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
vim.keymap.set("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {noremap=true})

local function nvimtree_on_attach(bufnr)
     local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    nvimtree.config.mappings.default_on_attach(bufnr)

    vim.keymap.del('n', 'K', { buffer = bufnr })
    vim.keymap.del('n', 'r', { buffer = bufnr })
    vim.keymap.del('n', '<C-e>', { buffer = bufnr })
    vim.keymap.del('n', 'o', { buffer = bufnr })

    vim.keymap.set('n', 'K', nvimtree.node.show_info_popup, opts('Info'))
    vim.keymap.set('n', 'r', nvimtree.fs.rename_full, opts('Rename'))
    vim.keymap.set('n', 'o', nvimtree.tree.change_root_to_node, opts('CD'))

end

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')


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

require("lspconfig").pyright.setup{
  capabilities = capabilities
}

require("nvim-tree").setup({
  on_attach = nvimtree_on_attach,
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


require("toggleterm").setup{
  -- size can be a number or function which is passed the current terminal
  size = 15,
  highlights = {
    -- highlights which map to a highlight group name and a table of it's values
    -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
    Normal = {
      link = 'Normal'
    },
    NormalFloat = {
      link = 'Normal'
    },
  },
  shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = true,
  persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
  direction = 'horizontal',
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell,
  auto_scroll = true, -- automatically scroll to the bottom on terminal output
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = 'curved',
    -- like `size`, width, height, row, and col can be a number or function which is passed the current terminal
   --  width = <value>,
   --  height = <value>,
   --  row = <value>,
   --  col = <value>,
    winblend = 3,
    zindex = 1,
    title_pos = 'left',
  },
  winbar = {
    enabled = false,
    name_formatter = function(term) --  term: Terminal
      return term.name
    end
  },
}


END


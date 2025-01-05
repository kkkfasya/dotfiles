call plug#begin()

Plug 'nvim-lualine/lualine.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'nvim-lua/plenary.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'

Plug 'kkkfasya/timelapse.nvim' " my own plugin!!!
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'ej-shafran/compile-mode.nvim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'lukas-reineke/indent-blankline.nvim'

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

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=100})
augroup END

inoremap /* /**/<Esc>hha

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

lua << END

vim.g.compile_mode = { baleia_setup = true }
vim.g.mapleader = " "

require("lualine").setup({
	options = { theme = "gruvbox" },
})

require("ibl").setup({})
require("nvim-autopairs").setup({
	enable_check_bracket_line = false,
})

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<Tab>"] = cmp.mapping(function(fallback)
			local col = vim.fn.col(".") - 1

			if cmp.visible() then
				cmp.select_next_item(select_opts)
			elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
				fallback()
			else
				cmp.complete()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
	}, {
		{ name = "buffer" },
	}),
})

require("gruvbox").setup({
	terminal_colors = true,
	underline = false,
	bold = false,
	italic = {
		folds = true,
	},
	inverse = true, -- invert background for search, diffs, statuslines and errors
	contrast = "soft",
	palette_overrides = {},
	overrides = {
		["@lsp.type.function"] = { fg = "#ff9900" },
		["@lsp.type.method"] = { fg = "#ff9900" },
		["@lsp.type.macro"] = { fg = "#fabd2f" },
		["@lsp.type.property"] = { fg = "#ebdbb2" },
	},
	dim_inactive = false,
	transparent_mode = false,
})

vim.cmd("colorscheme gruvbox")


vim.keymap.set("n", "<leader>C", ":w | :Compile<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cc", ":w | :Recompile<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bb", ":b#<CR>", {})
vim.keymap.set("n", "<leader>bn", ":bn<CR>", {})
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

END

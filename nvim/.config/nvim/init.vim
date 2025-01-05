call plug#begin()

Plug 'neovim/nvim-lspconfig'
Plug 'folke/todo-comments.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'folke/trouble.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'AlexeySachkov/llvm-vim'

Plug 'leafo/moonscript-vim' " NOTE: remove

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'nvim-lualine/lualine.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'kkkfasya/timelapse.nvim' " my own plugin!!!
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'projekt0n/github-nvim-theme'
Plug 'aktersnurra/no-clown-fiesta.nvim'
Plug 'https://github.com/junegunn/seoul256.vim'

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
Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'ej-shafran/compile-mode.nvim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'famiu/bufdelete.nvim'

call plug#end()


let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-d>'
let g:VM_maps['Find Subword Under'] = '<C-d>'
let g:seoul256_background = 234

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=100})
augroup END
inoremap /* /**/<Esc>hha

let g:VM_default_mappings = 0

nnoremap <silent> <C-Left> :vertical resize +3<CR>
nnoremap <silent> <C-Right> :vertical resize -3<CR>

nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

set clipboard+=unnamedplus
aunmenu PopUp.How-to\ disable\ mouse
aunmenu PopUp.-1-

set so=7
set number relativenumber
autocmd InsertLeave * :set number relativenumber
autocmd InsertEnter * :set number norelativenumber

au FocusLost * silent! wall
au BufLeave * silent! wall
au BufWinEnter,WinEnter term://* startinsert

set undodir=~/.nvim_undodir
set undofile
set autowriteall

set autoindent expandtab sw=4 ts=4
set mouse=a
set encoding=UTF-8
set background=dark
set noshowmode
set title
set noswapfile
set signcolumn=yes
set splitbelow

lua << END
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.compile_mode = { baleia_setup = true }

-- Mappings
local telescope = require("telescope.builtin")

vim.keymap.set("n", "<C-Up>", ":resize +3<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -3<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>e", ":NvimTreeOpen<CR>", { noremap = true })
vim.keymap.set("n", "<leader>p", telescope.find_files, {})
-- vim.keymap.set('n', '<C-f>', telescope.live_grep, {})
vim.keymap.set("n", "<leader>f", function()
	telescope.grep_string({ search = vim.fn.input("grep > ") })
end)

vim.keymap.set("n", "<leader>bs", telescope.buffers, {})
vim.keymap.set("n", "<leader>bb", ":b#<CR>", {})
vim.keymap.set("n", "<leader>bn", ":bn<CR>", {})

vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
vim.keymap.set("n", "gr", telescope.lsp_references, {})
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true})
vim.keymap.set("n", "E", vim.diagnostic.open_float, {})
vim.keymap.set("n", "ge", vim.diagnostic.goto_next)
vim.keymap.set("n", "gE", vim.diagnostic.goto_prev)

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { noremap = true })
vim.keymap.set("n", "<leader>C", ":w | :Compile<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cc", ":w | :Recompile<CR>", { noremap = true, silent = true })

local function nvimtree_on_attach(bufnr)
    local nvimtree = require("nvim-tree.api")
	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end
	nvimtree.config.mappings.default_on_attach(bufnr)
	vim.keymap.del("n", "K", { buffer = bufnr })
	vim.keymap.del("n", "r", { buffer = bufnr })
	vim.keymap.del("n", "<C-e>", { buffer = bufnr })
	vim.keymap.del("n", "o", { buffer = bufnr })
	vim.keymap.del("n", "d", { buffer = bufnr })
	vim.keymap.del("n", "Y", { buffer = bufnr })

	vim.keymap.set("n", "K", nvimtree.node.show_info_popup, opts("Info"))
	vim.keymap.set("n", "r", nvimtree.fs.rename_full, opts("Rename"))
	vim.keymap.set("n", "o", nvimtree.tree.change_root_to_node, opts("CD"))
	vim.keymap.set("n", "d", nvimtree.fs.trash, opts("Trash file"))
	vim.keymap.set("n", "Y", nvimtree.fs.copy.absolute_path, opts("Info"))
end

local function quickfix()
	vim.lsp.buf.code_action({
		filter = function(a)
			return a.isPreferred
		end,
		apply = true,
	})
end

vim.keymap.set("n", "<leader>qf", quickfix, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>qq", "<cmd>Bdelete<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Commands
vim.api.nvim_create_user_command("DiagnosticsToggle", function()
	local current_value = vim.diagnostic.is_disabled()
	if current_value then
		vim.diagnostic.enable()
	else
		vim.diagnostic.disable()
	end
end, {})

-- LSP
vim.diagnostic.config({
	update_in_insert = false,
})

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "clangd" },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lspconfig").lua_ls.setup({
	capabilities = capabilities,
})

require("lspconfig").clangd.setup({
	capabilities = capabilities,
})

require("lspconfig").pyright.setup({
	capabilities = capabilities,
})

require("lspconfig").ts_ls.setup({
	capabilities = capabilities,
})

require("lspconfig").rust_analyzer.setup({
	check_on_save = false,
	capabilities = capabilities,
})

-- AutoComplete
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
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
	matching = { disallow_symbol_nonprefix_matching = false },
})

-- TS
require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua" },
	sync_install = false,
	auto_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

-- Colorscheme
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
vim.cmd("hi! link SignColumn Normal")

-- Others
require("ibl").setup({})
require("bufferline").setup({})
require("todo-comments").setup({})
require("trouble").setup({})
require("lualine").setup({
	options = { theme = "gruvbox" },
})

require("Comment").setup({
	opleader = {
		---Line-comment keymap
		line = "<C-_>",
	},
	toggler = {
		---Line-comment toggle keymap
		line = "<C-_>",
	},
})

require("nvim-tree").setup({
	on_attach = nvimtree_on_attach,
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 30,
	},
	filters = {
        custom = {"^\\.git"}
	},
})

require("goto-preview").setup({
	post_open_hook = function(buf, win)
		vim.keymap.set("n", "q", "<cmd>lua require('goto-preview').close_all_win()<CR>", { noremap = true })
	end,
})

require("nvim-autopairs").setup({
	enable_check_bracket_line = false,
})


END


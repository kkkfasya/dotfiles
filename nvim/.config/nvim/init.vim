call plug#begin()

Plug 'neovim/nvim-lspconfig'
Plug 'folke/todo-comments.nvim'
Plug 'stevearc/conform.nvim'

Plug 'Saghen/blink.cmp'
Plug 'rafamadriz/friendly-snippets' 

Plug 'folke/trouble.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'AlexeySachkov/llvm-vim'

Plug 'L3MON4D3/LuaSnip'

Plug 'nvim-lualine/lualine.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'kkkfasya/timelapse.nvim' " my own plugin!!!
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'projekt0n/github-nvim-theme'
Plug 'aktersnurra/no-clown-fiesta.nvim'
Plug 'https://github.com/junegunn/seoul256.vim'
Plug 'lewis6991/gitsigns.nvim'

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

autocmd FileType php set iskeyword+=$

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
set hidden

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
vim.keymap.set("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true })
vim.keymap.set("n", "E", vim.diagnostic.open_float, {})
vim.keymap.set("n", "ge", vim.diagnostic.goto_next)
vim.keymap.set("n", "gE", vim.diagnostic.goto_prev)

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { noremap = true })
vim.keymap.set("n", "<leader>C", ":w | :Compile<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cc", ":w | :Recompile<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "F", ":Format<CR>", { noremap = true, silent = true })

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

vim.api.nvim_create_user_command("ListSymbols", function()
	vim.cmd(":lua require'telescope.builtin'.treesitter{}")
end, {})

vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

-- LSP
vim.diagnostic.disable()

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "clangd", "ts_ls", "pyright" },
})

-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- local capabilities = require('blink.cmp').get_lsp_capabilities()

local lspconfig_defaults = require("lspconfig").util.default_config

lspconfig_defaults.capabilities =
	vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("blink.cmp").get_lsp_capabilities())

require("lspconfig").lua_ls.setup({})

require("lspconfig").clangd.setup({})

require("lspconfig").pyright.setup({})

require("lspconfig").ts_ls.setup({})

-- require("lspconfig").phpactor.setup({
-- 	capabilities = capabilities,
--     init_options = {
--         ["language_server_phpstan.enabled"] = true,
--         ["language_server_psalm.enabled"] = true,
--     },
--     root_dir = function(_)
--         return vim.loop.cwd()
--     end,
-- })

require("lspconfig").intelephense.setup({
	check_on_save = false,
	capabilities = capabilities,
	root_dir = function(_)
		return vim.loop.cwd()
	end,
})

require("lspconfig").rust_analyzer.setup({
	check_on_save = false,
	capabilities = capabilities,
})

-- AutoComplete | CMP
require("blink.cmp").setup({
	cmdline = { enabled = true },
	fuzzy = { implementation = "prefer_rust" },

	completion = {
		keyword = { range = "full" },
		accept = { auto_brackets = { enabled = true } },
		list = { selection = { preselect = true, auto_insert = true } },

		menu = {
			auto_show = true,
			draw = {
				columns = {
					{ "label", "label_description", gap = 1 },
					{ "kind_icon", "kind" },
				},
				treesitter = { "lsp" },
			},
		},

		documentation = { auto_show = true, auto_show_delay_ms = 100 },

		-- Display a preview of the selected item on the current line
		ghost_text = { enabled = true },
	},

	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},

	-- Use a preset for snippets, check the snippets documentation for more information
	snippets = { preset = "luasnip" },

	-- Experimental signature help support
	signature = { enabled = true },

	keymap = {
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<C-p>"] = { "select_prev", "fallback_to_mappings" },
		["<C-n>"] = { "select_next", "fallback_to_mappings" },
		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },

		["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
	},

	cmdline = {
		keymap = {
			["<Tab>"] = { "show", "accept" },
			["<Down>"] = { "select_next", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },
		},
		completion = { menu = { auto_show = true } },
	},
})

-- TreeSitter (TS)
require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua", "python", "javascript", "typescript" },
	sync_install = false,
	auto_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
})

-- Formatter
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettier" },
		sql = { "sql-formatter" },
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


-- Git
require('gitsigns').setup{
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']g', function()
      if vim.wo.diff then
        vim.cmd.normal({']g', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[g', function()
      if vim.wo.diff then
        vim.cmd.normal({'[g', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Actions

    map('v', 'gs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('v', 'gr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('n', '<leader>gS', gitsigns.stage_buffer)
    map('n', '<leader>gR', gitsigns.reset_buffer)
    map('n', '<leader>gh', gitsigns.preview_hunk)

    map('n', '<leader>gb', function()
      gitsigns.blame_line({ full = true })
    end)

    map('n', '<leader>gd', gitsigns.diffthis)

    map('n', '<leader>hD', function()
      gitsigns.diffthis('~')
    end)

    -- Toggles
    map('n', '<leader>td', gitsigns.toggle_deleted)
    map('n', '<leader>tw', gitsigns.toggle_word_diff)
  end
}



-- Others
require("ibl").setup({})
require("bufferline").setup({})
require("todo-comments").setup({
	highlight = { multiline = false },
})
require("trouble").setup({})
require("lualine").setup({
	options = { theme = "gruvbox" },
})
require("telescope").setup({
	defaults = {
		layout_config = {
			height = 0.5,
			preview_cutoff = 200,
			prompt_position = "bottom",
			width = 0.5,
		},
	},

	pickers = {
		find_files = {
			no_ignore_parent = true,
			no_ignore = true,
			hidden = true,
			file_ignore_patterns = { "node_modules", ".git", ".venv" },
		},
	},
})

require("Comment").setup({
	opleader = {
		line = "<C-_>",
	},
	toggler = {
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
		custom = { "^\\.git" },
		exclude = { ".gitignore" },
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


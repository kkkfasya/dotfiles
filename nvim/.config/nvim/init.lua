local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local options = {
	tabstop = 4,
	shiftwidth = 4,
	expandtab = true,
	number = true,
	relativenumber = true,
	autoindent = true,
	showmode = false,
	title = true,
	swapfile = false,
	breakindent = true,
	hidden = true,
	undofile = true,
	autowriteall = true,
	termguicolors = true,
	splitbelow = true,
	scrolloff = 7,
	mouse = "a",
	encoding = "UTF-8",
	background = "dark",
	signcolumn = "yes",
}

for key, value in pairs(options) do
	vim.opt[key] = value
end

vim.g.mapleader = " "
vim.opt.undodir = os.getenv("HOME") .. "/.nvim_undodir/"
vim.opt.clipboard:append("unnamedplus")
vim.cmd([[filetype plugin on]]) -- this somehow fix the bug where neovim cant detect filetype for me

-- for nvimtree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.compile_mode = { baleia_setup = true }

vim.cmd([[aunmenu PopUp.How-to\ disable\ mouse]])
vim.cmd([[aunmenu PopUp.-1-]])

vim.g.VM_maps = {
	["Find Under"] = "<C-d>",
	["Find Subword Under"] = "<C-d>",
	["I Return"] = "<S-CR>",
	["Add Cursor Down"] = "",
	["Add Cursor Up"] = "",
}

-- AUGRUP AND AUTOCMD
vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = "highlight_yank",
	pattern = "*",
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 100 })
	end,
	desc = "Highlight yanked text",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "php",
	callback = function()
		vim.opt.iskeyword:append("$")
	end,
	desc = "Add $ to iskeyword for PHP files",
})

vim.api.nvim_create_augroup("number_toggle", { clear = true })
vim.api.nvim_create_autocmd("InsertLeave", {
	group = "number_toggle",
	pattern = "*",
	callback = function()
		vim.opt.number = true
		vim.opt.relativenumber = true
	end,
	desc = "Enable number and relativenumber on insert leave",
})

vim.api.nvim_create_autocmd("InsertEnter", {
	group = "number_toggle",
	pattern = "*",
	callback = function()
		vim.opt.number = true
		vim.opt.relativenumber = false
	end,
	desc = "Enable number, disable relativenumber on insert enter",
})

-- Autosave on focus lost or buffer leave
vim.api.nvim_create_augroup("autosave", { clear = true })
vim.api.nvim_create_autocmd("FocusLost", {
	group = "autosave",
	pattern = "*",
	callback = function()
		if vim.bo.buftype == "" and vim.bo.modified then
			vim.cmd("wall!")
		end
	end,
	desc = "Save all buffers on focus lost",
})

vim.api.nvim_create_autocmd("BufLeave", {
	group = "autosave",
	pattern = "*",
	callback = function()
		if vim.bo.buftype == "" and vim.bo.modified then
			vim.cmd("wall!")
		end
	end,
	desc = "Save all buffers on buffer leave",
})

-- Start insert mode in terminal buffers
vim.api.nvim_create_augroup("terminal", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
	group = "terminal",
	pattern = "term://*",
	command = "startinsert",
	desc = "Enter insert mode in terminal buffers",
})

local COLORSCHEME = {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			terminal_colors = true,
			underline = false,
			bold = false,
			italic = {
				strings = false,
			},
			inverse = true, -- invert background for search, diffs, statuslines and errors
			contrast = "hard",
			palette_overrides = {},
			overrides = {
				["@function"] = { fg = "#ff9900" },
				["@function.method"] = { fg = "#ff9900" },
				["@function.call"] = { fg = "#ff9900" },
				["@constant.macro"] = { fg = "#fabd2f" },
				["@property"] = { fg = "#ebdbb2" },
				["DiagnosticUnnecessary"] = { fg = "#ebdbb2" },
			},
			dim_inactive = false,
			transparent_mode = false,
		})

		vim.cmd([[colorscheme gruvbox]])
	end,
}

local FORMATTER = {
	"stevearc/conform.nvim",
	lazy = true,

	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff" }, -- WARNING: dont know if it works
				rust = { "rustfmt" },
				go = { "goimports", "gofmt" },
				javascript = { "oxfmt" },
				typescript = { "oxfmt" },
				tsx = { "oxfmt", "prettier" },
				svelte = { "oxfmt", "prettier" },
				astro = { "oxfmt", "prettier" },
				css = { "oxfmt", "prettier" },
				html = { "oxfmt", "prettier" },
				sql = { "sql-formatter" },
				md = { "mdformat" },
				terraform = { "terraform_fmt" },
			},
		})
	end,
	keys = function()
		vim.keymap.set("n", "F", ":Format<CR>", { noremap = true })
	end,
}

local TELESCOPE = {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim", "natecraddock/telescope-zf-native.nvim" },
	lazy = true,
	opts = {
		--		defaults = {
		--			layout_config = {
		--				height = 0.5,
		--				preview_cutoff = 200,
		--				prompt_position = "bottom",
		--				width = 0.5,
		--			},
		--		},

		pickers = {
			find_files = {
				hidden = true,
				no_ignore = true,
				file_ignore_patterns = {
					".vscode/",
					".astro/",
					".mypy_cache/",
					"node_modules/",
					".terraform/",
					".git/",
					".venv/",
					".ruff_cache/",
					".pytest_cache/",
					".__pycache__/",
					".svelte-kit/",
					"dist/",
					"build/",
					"target/",
				},
			},
		},
	},

	keys = function()
		local telescope = require("telescope.builtin")
		-- vim.keymap.set("n", "<leader>p", telescope.find_files, {})

		vim.keymap.set("n", "<leader>f", function()
			telescope.grep_string({ search = vim.fn.input("grep > ") })
		end)
		vim.keymap.set("n", "gr", telescope.lsp_references, {})
		vim.keymap.set("n", "<leader>bs", telescope.buffers, {})
		vim.keymap.set("n", "<leader>sw", telescope.git_branches, {})

		require("telescope").load_extension("zf-native")
	end,
}

local FFF = {
	"dmtrKovalenko/fff.nvim",
	build = function()
		require("fff.download").download_or_build_binary()
	end,
	-- if you are using nixos
	-- build = "nix run .#release",
	opts = {
		debug = {
			enabled = false,
			show_scores = false,
		},
		prompt = "> ",
	},
	lazy = false,

	keys = {
		{
			"<leader>p", -- try it if you didn't it is a banger keybinding for a picker
			function()
				require("fff").find_files()
			end,
			desc = "FFFind files",
		},
	},
}

local FILESYSTEM = {
	{
		"stevearc/oil.nvim",
		opts = {
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			watch_for_changes = true,
			keymaps = {
				["g?"] = { "actions.show_help", mode = "n" },
				["<CR>"] = "actions.select",
				["v"] = { "actions.select", opts = { vertical = true } },
				["h"] = { "actions.select", opts = { horizontal = true } },
				["P"] = "actions.preview",
				["q"] = { "actions.close", mode = "n" },
				["r"] = "actions.refresh",
				["-"] = { "actions.parent", mode = "n" },
				["_"] = { "actions.open_cwd", mode = "n" },
				-- ["o"] = { "actions.cd", mode = "n" },
				["gs"] = { "actions.change_sort", mode = "n" },
				["gx"] = "actions.open_external",
				["g."] = { "actions.toggle_hidden", mode = "n" },
				["t"] = { "actions.toggle_trash", mode = "n" },
			},
			view_options = {
				show_hidden = true,
			},
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },

		lazy = false,
		keys = function()
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		lazy = true,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local function nvimtree_on_attach(bufnr)
				local nvimtree = require("nvim-tree.api")
				local function opts(desc)
					return {
						desc = "nvim-tree: " .. desc,
						buffer = bufnr,
						noremap = true,
						silent = true,
						nowait = true,
					}
				end
				nvimtree.config.mappings.default_on_attach(bufnr)
				vim.keymap.del("n", "K", { buffer = bufnr })
				vim.keymap.del("n", "r", { buffer = bufnr })
				vim.keymap.del("n", "<C-e>", { buffer = bufnr })
				vim.keymap.del("n", "o", { buffer = bufnr })
				vim.keymap.del("n", "d", { buffer = bufnr })
				vim.keymap.del("n", "Y", { buffer = bufnr })
				vim.keymap.del("n", "s", { buffer = bufnr })
				vim.keymap.del("n", "S", { buffer = bufnr })
				vim.keymap.del("n", "f", { buffer = bufnr })

				vim.keymap.set("n", "K", nvimtree.node.show_info_popup, opts("Info"))
				vim.keymap.set("n", "r", nvimtree.fs.rename_full, opts("Rename"))
				vim.keymap.set("n", "o", nvimtree.tree.change_root_to_node, opts("CD"))
				vim.keymap.set("n", "d", nvimtree.fs.trash, opts("Trash file"))
				vim.keymap.set("n", "Y", nvimtree.fs.copy.absolute_path, opts("Info"))
				vim.keymap.set("n", "f", nvimtree.tree.search_node, opts("Info"))
			end

			require("nvim-tree").setup({
				on_attach = nvimtree_on_attach,
				sort = {
					sorter = "case_sensitive",
				},
				view = {
					width = 27,
				},
				filters = {
					dotfiles = true,
					custom = { "^\\.git" },
					exclude = { ".gitignore", ".github" },
				},
			})
		end,
		cmd = { "NvimTreeOpen" },
		keys = function()
			vim.keymap.set("n", "<leader>e", ":NvimTreeOpen<CR>", { noremap = true, silent = true })
		end,
	},
}

local TREESITTER = {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile", "CmdlineEnter" },
	cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"c",
				"lua",
				"python",
				"javascript",
				"typescript",
				"php",
				"go",
				"html",
				"css",

				"tsx",
				"svelte",

				"hcl",
				"terraform",

				"make",
				"cmake",

				"ledger",
			},
			sync_install = false,
			auto_install = false,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
				priority = 200, -- Increase priority (default is ~100)
			},
			indent = { enable = true },
		})
	end,
}

local MISC = {
	-- extra colorscheme
	{ "talha-akram/noctis.nvim", lazy = true, event = "CmdlineEnter" },
	{ "binhtran432k/dracula.nvim", lazy = true, event = "CmdlineEnter" },
	{ "kkkfasya/frappeless.nvim", lazy = true, event = "CmdlineEnter" },
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{ "AlexeySachkov/llvm-vim", lazy = true, ft = "llvm" },
	{ "https://github.com/pigpigyyy/YueScript-vim" },

	{ "mg979/vim-visual-multi", lazy = true, event = { "BufReadPost", "BufNewFile" } },
	{ "akinsho/bufferline.nvim", lazy = true, opts = {}, event = "BufReadPost" },
	{ "kkkfasya/timelapse.nvim", lazy = true, cmd = { "Timelapse" } }, -- my own plugin!!!
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		lazy = true,
		cmd = { "Neogit" },
		opts = {
			integrations = { diffview = true, telescope = true },
			graph_style = "kitty",
			process_spinner = true,
			mappings = {
				status = {
					["<esc>"] = "Close",
					["<space>"] = "Toggle",
				},
				popup = {
					["p"] = "PushPopup",
					["P"] = "PullPopup",
				},
			},
		},
		keys = function()
			vim.keymap.set("n", "<leader>n", "<cmd>Neogit<CR>", { noremap = true, silent = true })
		end,
	},
	{
		"windwp/nvim-autopairs",
		lazy = true,
		event = "InsertEnter",
		opts = { enable_check_bracket_line = false },
	},

	{
		"catgoose/nvim-colorizer.lua",
		lazy = false,
		opts = { names = false },
	},

	{
		"folke/trouble.nvim",
		lazy = true,
		opts = {},
		cmd = { "Trouble" },
		keys = function()
			vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { noremap = true })
		end,
	},

	{
		"folke/todo-comments.nvim",
		event = "BufReadPost",
		opts = { highlight = { multiline = false } },
	},

	{
		"famiu/bufdelete.nvim",
		lazy = true,
		cmd = { "Bdelete" },
		keys = function()
			-- TODO: add keymap to delete all buffer, <leader>qa
			vim.keymap.set("n", "<leader>qq", "<cmd>Bdelete<CR>", { noremap = true, silent = true })
		end,
	},
	{
		"ej-shafran/compile-mode.nvim",
		lazy = true,
		cmd = { "Compile", "Recompile" },
		dependencies = {
			{ "m00qek/baleia.nvim", tag = "v1.3.0" },
		},
		keys = function()
			vim.keymap.set("n", "<leader>C", ":w | :Compile<CR>", { noremap = true })
			vim.keymap.set("n", "<leader>cc", ":w | :Recompile<CR>", { noremap = true })
		end,
	},

	{
		"rmagatti/goto-preview",
		lazy = true,
		opts = {
			post_open_hook = function(buf, win)
				vim.keymap.set("n", "q", "<cmd>lua require('goto-preview').close_all_win()<CR>", { noremap = true })
			end,
		},
		keys = function()
			vim.keymap.set(
				"n",
				"gp",
				"<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
				{ noremap = true }
			)
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		opts = { theme = "auto" },
		config = function(_, opts)
			require("lualine").setup({
				options = opts,
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		event = "BufReadPre",
		opts = {
			opleader = {
				line = "<C-_>",
			},
			toggler = {
				line = "<C-_>",
			},
		},
	},

	{
		"folke/snacks.nvim",
		priority = 1000,
		opts = {
			quickfile = { enabled = true },
			image = { enabled = true },
			indent = {
				priority = 1,
				enabled = true,
				char = "│",
				only_scope = false,
				only_current = false,
				hl = "SnacksIndent",
				animate = { enabled = false }, -- fuck aniamation bro
			},
		},
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	{
		"Bekaboo/dropbar.nvim",
		config = function()
			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
			vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
			vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
		end,
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {
			modes = {
				char = {
					enabled = false,
				},
			},
		},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},

	{
		"ionide/Ionide-vim",
		ft = { "fsharp", "fsharp_project" },
		config = function()
			vim.g["fsharp#fsi_window_command"] = "vnew"
		end,
	},
	{
		"folke/zen-mode.nvim",
		opts = {},

		lazy = true,
		cmd = { "ZenMode" },
	},
	{
		"dariuscorvus/tree-sitter-language-injection.nvim",
		opts = {}, -- calls setup()
	},
}

local VSCODE = {
	"vscode-neovim/vscode-multi-cursor.nvim",
	event = "VeryLazy",
	cond = not not vim.g.vscode,
	opts = {},
	config = function()
		vim.keymap.set({ "n", "x", "i" }, "<C-d>", function()
			require("vscode-multi-cursor").addSelectionToNextFindMatch()
		end)
		require("vscode-multi-cursor").setup()
	end,
}

local GITSIGNS = {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPre",
	opts = {
		on_attach = function(buffer)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
			end

			map("n", "]g", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gs.nav_hunk("next")
				end
			end, "Next Hunk")

			map("n", "[g", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gs.nav_hunk("prev")
				end
			end, "Prev Hunk")

			map("n", "]H", function()
				gs.nav_hunk("last")
			end, "Last Hunk")
			map("n", "[H", function()
				gs.nav_hunk("first")
			end, "First Hunk")

			map("v", "ga", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end)

			map("v", "gr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end)

			map("n", "<leader>ga", gs.stage_buffer, "Stage Buffer")
			map("n", "<leader>gr", gs.reset_buffer, "Reset Buffer")
			map("n", "<leader>gh", gs.preview_hunk_inline, "Preview Hunk Inline")

			map("n", "<leader>gb", function()
				gs.blame()
			end, "Blame Buffer")

			map("n", "<leader>ghd", gs.diffthis, "Diff This")
			map("n", "<leader>ghD", function()
				gs.diffthis("~")
			end, "Diff This ~")

			map("n", "<leader>td", gs.toggle_deleted)
			map("n", "<leader>tw", gs.toggle_word_diff)
		end,
	},
}

local AUTOCOMPLETE = {
	"Saghen/blink.cmp",
	version = "1.*",
	event = { "BufReadPost", "CmdlineEnter" },
	dependencies = {
		{ "rafamadriz/friendly-snippets" },
	},
	opts = {
		fuzzy = {
			implementation = "prefer_rust",
			sorts = {
				function(a, b)
					if (a.client_name == nil or b.client_name == nil) or (a.client_name == b.client_name) then
						return
					end
					return b.client_name == "emmet_language_server"
				end,
				-- default sorts
				"score",
				"sort_text",
				"exact",
				"score",
				"sort_text",
			},
		},

		completion = {
			keyword = { range = "full" },

			-- trigger = {
			-- 	show_on_trigger_character = true,
			-- 	show_on_blocked_trigger_characters = { " ", "\n", "\t" },
			-- },

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

			ghost_text = { enabled = true },
		},

		sources = {
			providers = {
				buffer = {
					opts = {
						get_bufnrs = function()
							return vim.tbl_filter(function(bufnr)
								return vim.bo[bufnr].buftype == ""
							end, vim.api.nvim_list_bufs())
						end,
					},
				},
			},
			-- default = { "path", "buffer", },
			default = { "lsp", "path", "buffer" },
		},

		signature = { enabled = true },

		keymap = {
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = { "select_next", "fallback" },
			["<Down>"] = { "select_next", "select_next" },
			["<Up>"] = { "select_prev", "select_prev" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },
			["<C-p>"] = { "select_prev", "fallback_to_mappings" },
			["<C-n>"] = { "select_next", "fallback_to_mappings" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },

			["<C-k>"] = { "show", "hide", "fallback" },
		},

		cmdline = {
			keymap = {
				["<Tab>"] = { "show", "accept" },
				["<Down>"] = { "select_next", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
			},
			completion = { menu = { auto_show = true } },
		},
	},
}

local LSPCONFIG = {
	"neovim/nvim-lspconfig",
	lazy = true,
	event = "BufRead",
	priority = 1001,
	dependencies = {
		{ "mason-org/mason.nvim", opts = {}, event = "CmdlineEnter" },
		{
			"WhoIsSethDaniel/mason-tool-installer",
			opts = {
				ensure_installed = {
					"stylua",
					"ruff",
					"rustfmt",
					"goimports",
					"prettier",
					"prettier",
					"sql-formatter",
					"mdformat",
					"marksman",
				},
				integrations = {
					["mason-lspconfig"] = true,
					["mason-nvim-dap"] = true,
				},
			},
		},
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				ensure_installed = {
					"astro",
					"gopls",
					"lua_ls",
					"clangd",
					"vtsls",
					"pyright",
					"html",
					"cssls",
					"emmet_language_server",
					"tailwindcss",
					"svelte",
					"rust_analyzer",
					"jsonls",
					"terraformls",
				},
			},
		},
	},

	opts = {
		servers = {
			marksman = {},
			lua_ls = {},
			gopls = {},
			clangd = {},
			pyright = {
				root_dir = function(_)
					return vim.loop.cwd()
				end,
			},
			vtsls = {
				settings = {
					typescript = {
						preferences = {
							includeCompletionsForModuleExports = true,
							includeCompletionsForImportStatements = true,
							importModuleSpecifier = "non-relative",
						},
					},
				},
			},
			html = {
				format = {
					templating = true,
					wrapLineLength = 120,
					wrapAttributes = "auto",
				},
				hover = {
					documentation = true,
					references = true,
				},
			},

			rust_analyzer = { check_on_save = false },
			bacon_ls = {},
			intelephense = {
				check_on_save = false,
				root_dir = function(_)
					return vim.loop.cwd()
				end,
			},

			-- config language lsp
			json_ls = {},
			terraform_ls = {},
			rpm_lsp_server = {},

			-- extra web lsp
			tailwindcss = {},
			svelte = {},
			cssls = {},
			astro = {},
			emmet_language_server = {
				filetypes = { "html", "css", "php" },
			},
			--
		},
	},

	config = function(_, opts)
		local lspconfig_defaults = require("lspconfig").util.default_config
		lspconfig_defaults.capabilities =
			vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("blink.cmp").get_lsp_capabilities())
	end,

	-- im not very fond of the way lazy setup lazy-keymap but thankfully folke allows function
	-- so i can set it up the normal way
	keys = function()
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})

		vim.keymap.set("n", "gv", function()
			local wins = vim.api.nvim_tabpage_list_wins(0)
			if #wins == 1 then
				vim.cmd("vsplit")
				vim.cmd("wincmd l") -- always jump to right split
			else
				vim.cmd("wincmd l") -- always jump to right split
			end
			vim.lsp.buf.definition()
		end, { silent = true })

		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
		vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
		vim.keymap.set("n", "E", vim.diagnostic.open_float, {})
		vim.keymap.set("n", "ge", vim.diagnostic.goto_next, {})
		vim.keymap.set("n", "gE", vim.diagnostic.goto_prev, {})
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
		vim.keymap.set("n", "<leader>qf", function()
			vim.lsp.buf.code_action({
				filter = function(a)
					return a.isPreferred
				end,
				apply = true,
			})
		end, { noremap = true, silent = true })
	end,
}

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

-- General Mappings
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize +3<CR>", { silent = true, desc = "Increase window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize -3<CR>", { silent = true, desc = "Decrease window width" })
vim.keymap.set("n", "<C-Up>", ":horizontal resize +3<CR>", { silent = true, desc = "Increase window width" })
vim.keymap.set("n", "<C-Down>", ":horizontal resize -3<CR>", { silent = true, desc = "Decrease window width" })

vim.keymap.set("n", "<leader>bb", ":b#<CR>", {})
vim.keymap.set("n", "<leader>bn", ":bn<CR>", {})

vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { silent = true, desc = "Move to window above" })
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { silent = true, desc = "Move to window below" })
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { silent = true, desc = "Move to window left" })
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { silent = true, desc = "Move to window right" })
vim.keymap.set({ "n", "v" }, "w", "e", {})

-- USER COMMANDS
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
	require("conform").format({ async = true, lsp_format = "never", range = range })
end, { range = true })

vim.api.nvim_create_user_command("VirtualTextToggle", function()
	local cfg = vim.diagnostic.config()

	local status = (not cfg.virtual_text) and "enabled" or "disabled"

	vim.diagnostic.config({
		virtual_text = not cfg.virtual_text,
	})

	print("Diagnostic virtual text is " .. status)
end, {})

vim.api.nvim_create_user_command("DiagnosticsToggle", function()
	local diagnostic = vim.diagnostic.is_enabled()
	vim.diagnostic.enable(not diagnostic)

	local status = (not diagnostic) and "enabled" or "disabled"
	print("Diagnostic is " .. status)
end, {})

require("lazy").setup({
	rocks = {
		enabled = false,
	},
	spec = {
		COLORSCHEME,
		FORMATTER,
		FILESYSTEM,
		GITSIGNS,
		LSPCONFIG,
		AUTOCOMPLETE,
		TELESCOPE,
		TREESITTER,
		VSCODE,
		FFF,
		MISC,
	},
	install = { colorscheme = { "gruvbox" } },
	checker = { enabled = false },
})

-- EXTRA
vim.g["fsharp#backend"] = "disable" -- lsp is configured by mason not ionide vim
vim.filetype.add({
	pattern = {
		[".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
	},
})

vim.diagnostic.config({
	virtual_text = false,
	underline = true, -- also turns off DiagnosticUnnecessary
})

-- DEV
-- local dev_client = vim.lsp.start({
--     name = "LSP-learn",
--     cmd = {"/home/nekraut/Programming/Go/LSP-learn/main"}
-- })
--
-- if not dev_client then
--     vim.notify "[DEV]: Client is not starting mannnnn"
-- end
--
-- -- XXX: cant start client
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "markdown",
-- 	callback = function()
--         vim.lsp.buf_attach_client(0, dev_client)
-- 	end,
-- })

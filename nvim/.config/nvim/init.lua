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
vim.opt.undodir = os.getenv("HOME") .. "/.local/state/.nvim_undodir/"
vim.opt.clipboard:append("unnamedplus")
vim.cmd([[filetype plugin on]]) -- this somehow fix the bug where neovim cant detect filetype for me

-- for nvimtree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
				python = { "ruff_format" },
				rust = { "rustfmt" },
				-- go = { "goimport", "gofmt" },
				go = { "gofmt" },
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
				nix = { "alejandra" },
			},
		})
	end,
	keys = function()
		vim.keymap.set("n", "F", ":Format<CR>", { noremap = true, silent = true })
	end,
}

local FFF = {
	"dmtrKovalenko/fff.nvim",
	build = function()
		require("fff.download").download_or_build_binary()
	end,
	lazy = false,
	opts = {
		debug = {
			enabled = false,
			show_scores = false,
		},
		prompt = "> ",
	},

	keys = {
		{
			"<leader>p",
			function()
				require("fff").find_files()
			end,
			desc = "FFFind files",
		},
		{
			"<leader>f",
			function()
				require("fff").live_grep()
			end,
			desc = "LiFFFE grep",
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
				-- ["<C-v>"] = { "actions.select", opts = { vertical = true } },
				-- ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
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
			float = {
				preview_split = "right",
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
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	config = function()
		-- Custom registrations
		vim.filetype.add({
			extension = {
				csproj = "xml",
				esproj = "xml",
				keymap = "c",
				mdx = "markdown",
				uproject = "json",
				wsdl = "xml",
			},
		})

		local treesitter_dir = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/"

		--Collect all available parsers
		local parsers = {}
		for name, type in vim.fs.dir(treesitter_dir .. "runtime/queries") do
			if type == "directory" then
				table.insert(parsers, name)
			end
		end

		require("nvim-treesitter").install(parsers)

		dofile(treesitter_dir .. "plugin/filetypes.lua")

		-- Get file types
		local file_types = vim.iter(parsers)
			:map(function(parser)
				return vim.treesitter.language.get_filetypes(parser)
			end)
			:flatten()
			:totable()

		-- Auto-run
		vim.api.nvim_create_autocmd("FileType", {
			pattern = file_types,
			callback = function(args)
				-- Highlights
				vim.treesitter.start()

				-- Folds
				-- vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				-- vim.wo[0][0].foldmethod = "expr"

				-- Indentation
				vim.bo[args.buf].indentexpr = 'v:lua.require"nvim-treesitter".indentexpr()'
			end,
		})
	end,
}

-- copied from: https://github.com/tobinjt/dotfiles/blob/master/.config/nvim/lua/plugins/debugging.lua
local DEBUGGER = {
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		-- Copied from LazyVim/lua/lazyvim/plugins/extras/dap/core.lua and
		-- modified.
		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},

			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},

			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},

			{
				"<leader>dT",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			-- Consider the mappings at
			-- https://github.com/mfussenegger/nvim-dap-python?tab=readme-ov-file#mappings
			{
				"<leader>dt",
				function()
					if vim.bo[0].filetype == "go" then
						require("dap-go").debug_test()
					elseif vim.bo[0].filetype == "python" then
						require("dap-python").test_method()
					else
						vim.print("No test support for " .. vim.bo[0].filetype)
					end
				end,
				desc = "Debug the test method above the cursor",
			},
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		config = true,
		keys = {
			{
				"<leader>ds",
				function()
					require("dapui").toggle({})
				end,
				desc = "Dap UI",
			},
		},
		dependencies = {
			{
				"jay-babu/mason-nvim-dap.nvim",
				opts = {
					-- This line is essential to making automatic installation work
					-- :exploding-brain
					handlers = {},
					automatic_installation = false,
					-- DAP servers: these will be installed by mason-tool-installer.nvim
					-- for consistency.
					ensure_installed = {},
				},
				dependencies = {
					"mfussenegger/nvim-dap",
					"mason-org/mason.nvim",
				},
			},
			{
				"leoluz/nvim-dap-go",
				config = true,
				dependencies = {
					"mfussenegger/nvim-dap",
				},
			},
			{
				"mfussenegger/nvim-dap-python",
				lazy = true,
				config = function()
					require("dap-python").setup("python3")
				end,
				dependencies = {
					"mfussenegger/nvim-dap",
				},
			},
			{
				"nvim-neotest/nvim-nio",
			},
			{
				"theHamsta/nvim-dap-virtual-text",
				config = true,
				dependencies = {
					"mfussenegger/nvim-dap",
				},
			},
		},
	},
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
	{ "kkkfasya/timelapse.nvim", lazy = true, cmd = { "Timelapse", "FTimelapse" } }, -- my own plugin!!!
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
		},
		lazy = true,
		cmd = { "Neogit" },
		opts = {
			integrations = { diffview = true },
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
		"ej-shafran/compile-mode.nvim",
		version = "^5.0.0",
		lazy = true,
		cmd = { "Compile", "Recompile" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "m00qek/baleia.nvim" },
		},
		config = function()
			---@type CompileModeOpts
			vim.g.compile_mode = {
				input_word_completion = true,
				-- baleia_setup = true,
			}
		end,
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
				vim.keymap.set("n", "q", function()
					vim.api.nvim_win_close(win, true)
				end, { buffer = buf, silent = true, nowait = true })

				vim.keymap.set("n", "Q", "<cmd>lua require('goto-preview').close_all_win()<CR>", { noremap = true })
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
		"selimacerbas/markdown-preview.nvim",
		dependencies = { "selimacerbas/live-server.nvim" },
		config = function()
			require("markdown_preview").setup({
				-- all optional; sane defaults shown
				instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
				port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
				open_browser = true,
				debounce_ms = 300,
			})
		end,
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
		opts = {
			plugins = {
				enabled = true,
				tmux = { enabled = true },
				todo = { enabled = false },
			},
		},

		lazy = true,
		cmd = { "ZenMode" },
	},
	{
		"dariuscorvus/tree-sitter-language-injection.nvim",
		opts = {}, -- calls setup()
	},
	{
		"karb94/neoscroll.nvim",
		opts = { mappings = {} },
		config = function()
			neoscroll = require("neoscroll")
			local keymap = {
				["<C-S-K>"] = function()
					neoscroll.ctrl_u({ duration = 70 })
				end,
				["<C-S-J>"] = function()
					neoscroll.ctrl_d({ duration = 70 })
				end,
			}
			local modes = { "n", "v", "x" }
			for key, func in pairs(keymap) do
				vim.keymap.set(modes, key, func)
			end
		end,
	},
	{
		"rachartier/tiny-cmdline.nvim",
		init = function()
			require("vim._core.ui2").enable({})
			vim.o.cmdheight = 0
			require("tiny-cmdline").setup({
				position = {
					y = "30%", -- vertical:   "0%" = top,  "50%" = center, "100%" = bottom
				},

				native_types = {},
				on_reposition = require("tiny-cmdline").adapters.blink,
			})
		end,
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
				"exact",
				-- default sorts
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
			-- default = { "lsp", "path", "buffer", "snippets" },
			default = function(ctx)
				local success, node = pcall(vim.treesitter.get_node)
				if
					success
					and node
					and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type())
				then
					return { "buffer" }
				elseif success and node and vim.tbl_contains({ "string" }, node:type()) then
					return { "lsp", "path", "buffer" }
				else
					return { "lsp", "path", "snippets", "buffer" }
				end
			end,
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

-- best nvim plugin OAT shoutout to folke
local SNACKS = {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		quickfile = { enabled = true },
		image = { enabled = true },
		-- input = {},
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

    -- stylua: ignore
    keys = {
        -- git
        { "<leader>sw", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
        { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
        { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
        { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
        { "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },

        { "<leader>xs", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },

        { "<leader>bs", function() Snacks.picker.buffers() end, desc = "Buffers" },

        -- others
        { "<leader>qq", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
        { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
        { "<leader>cs", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
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
			ty = {
				root_dir = function(_)
					return vim.loop.cwd()
				end,
				completions = {
					autoImport = false,
				},
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
			nil_ls = {},
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

		vim.keymap.set("n", "gv", ":vsplit<CR>gd", { silent = true })

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

-- GENERAL MAPPINGS
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize +3<CR>", { silent = true, desc = "Increase window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize -3<CR>", { silent = true, desc = "Decrease window width" })
vim.keymap.set("n", "<C-Up>", ":horizontal resize +3<CR>", { silent = true, desc = "Increase window width" })
vim.keymap.set("n", "<C-Down>", ":horizontal resize -3<CR>", { silent = true, desc = "Decrease window width" })

vim.keymap.set("n", "<leader>bb", ":b#<CR>", { silent = true })
vim.keymap.set("n", "<leader>bn", ":bn<CR>", {})

vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { silent = true, desc = "Move to window above" })
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { silent = true, desc = "Move to window below" })
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { silent = true, desc = "Move to window left" })
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { silent = true, desc = "Move to window right" })
vim.keymap.set({ "n", "v" }, "w", "e", {})

-- USER COMMANDS
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
		TREESITTER,
		VSCODE,
		FFF,
		SNACKS,
		DEBUGGER,
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

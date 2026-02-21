-- TODO: finish, test
--
-- barebones neovim config with some plugins, aims to be as light as possible while still being nice to use 
-- requires no external plugins manager, and use no LSP
--[[ 
features:
- autocomplete capabilities
- file management with oil.nvim
- zen mode for writing

this config is mainly used in VPS, not too much capabilities but just enough to make it comfortable
]]

-- TODO: swap to native vim.pack package manager once nvim 0.12+ is released in fedora
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

vim.cmd([[aunmenu PopUp.How-to\ disable\ mouse]])
vim.cmd([[aunmenu PopUp.-1-]])

-- Highlight copied text
vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = "highlight_yank",
	pattern = "*",
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 100 })
	end,
	desc = "Highlight yanked text",
})

-- Dynamic relative number
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

-- Autosave 
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
			default = { "path", "buffer" },
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

require("lazy").setup({
    rocks = {
        enabled = false,
    },

    spec = {
        { "binhtran432k/dracula.nvim", lazy = true, event = "CmdlineEnter" },
        FILESYSTEM,
        COLORSCHEME,
        AUTOCOMPLETE,

	{
		"windwp/nvim-autopairs",
		lazy = true,
		event = "InsertEnter",
		opts = { enable_check_bracket_line = false },
	},

	{
		"folke/todo-comments.nvim",
		event = "BufReadPost",
		opts = { highlight = { multiline = false } },
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
		"folke/snacks.nvim",
		priority = 1000,
		opts = {
			quickfil = { enabled = true },
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

    },
    install = { colorscheme = { "gruvbox" } },
    checker = { enabled = false },
})

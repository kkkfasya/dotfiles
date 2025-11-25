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

vim.g.mapleader = " "

-- Highlight on yank
vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = "highlight_yank",
	callback = function()
		vim.highlight.on_yank({ higroup = "CurSearch", timeout = 100 })
	end,
})

-- Clipboard
vim.opt.clipboard:append("unnamedplus")

-- Remove mouse popup menus (Note: this only applies to GUI versions that have these menus)
vim.cmd([[aunmenu PopUp.How-to\ disable\ mouse]])
vim.cmd([[aunmenu PopUp.-1-]])

-- Scroll offset and completion options
vim.opt.scrolloff = 7

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set number relativenumber",
})
vim.api.nvim_create_autocmd("InsertEnter", {
	pattern = "*",
	command = "set number norelativenumber",
})

-- Case sensitivity
vim.opt.smartcase = true
vim.api.nvim_create_autocmd("InsertEnter", {
	pattern = "*",
	command = "set noignorecase",
})
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set noignorecase",
})

-- Auto save on focus lost
vim.api.nvim_create_autocmd("FocusLost", {
	pattern = "*",
	command = "silent! wa",
})

-- Mouse and indentation settings
vim.opt.mouse = "a"
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.expandtab = true

-- Encoding, appearance, and behavior
vim.opt.encoding = "utf-8"
vim.opt.background = "dark"
vim.opt.showmode = false
vim.opt.title = true
vim.opt.swapfile = false

-- Tab completion mappings
vim.keymap.set("i", "<Tab>", 'pumvisible() and "<C-n>" or "<Tab>"', { expr = true, noremap = true })
vim.keymap.set("i", "<S-Tab>", 'pumvisible() and "<C-p>" or "<Tab>"', { expr = true, noremap = true })

local VSCODE = require("vscode")

-- Leader mappings for VSCode Neovim (requires vscode-neovim extension)
vim.keymap.set("n", "<Leader>p", function()
	VSCODE.action("workbench.action.quickOpen")
end, {})

vim.keymap.set("n", "<Leader>f", function()
	VSCODE.action("workbench.view.search")
end, {})

vim.keymap.set("n", "<Leader>e", function()
	VSCODE.action("workbench.view.explorer")
end, {})

vim.keymap.set("n", "<Leader>bb", function()
	VSCODE.action("workbench.action.navigateLast")
end, {})

vim.keymap.set("n", "E", function()
	VSCODE.action("workbench.action.problems.focus")
end, {})

vim.keymap.set("n", "gp", function()
	VSCODE.action("editor.action.peekDefinition")
end, {})

vim.keymap.set("n", "F", function()
	VSCODE.action("editor.action.formatDocument")
end, {})

vim.keymap.set("v", "ga", function()
	VSCODE.action("git.stageSelectedRanges")
end, {})

vim.keymap.set("v", "gr", function()
	VSCODE.action("git.revertSelectedRanges")
end, {})

require("lazy").setup({
	rocks = {
		enabled = false,
	},
	spec = {
		{
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
		},
	},

	install = { colorscheme = { "gruvbox" } },
	checker = { enabled = false },
})

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set({ "n", "v" }, "w", "e", {})

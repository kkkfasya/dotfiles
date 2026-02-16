-- TODO: finish, test
-- barebones neovim config with some plugins, aims to be as light as possible while still being nice to use 
-- requires no external plugins manager, and use no LSP
--[[ 
features:
    - autocomplete capabilities
    - file management with oil.nvim
    - zen mode for writing

this config is mainly used in VPS, not too much capabilities but just enough to make it comfortable
]]
--
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


-- Plugins install
vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "ellisonleao/gruvbox.nvim"},
	{ src = "christoomey/vim-tmux-navigator"},
	{ src = 		"nvim-lualine/lualine.nvim"},
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})



-- Plugins Setup
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

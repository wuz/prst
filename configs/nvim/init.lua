vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
	dev = {
		path = "~/dev/github/wuz",
		patterns = { "wuz", "cantrip.nvim", "lackluster.nvim" },
		fallback = false,
	},
	spec = {
		{
			"wuz/cantrip.nvim",
			dev = true,
			import = "cantrip.plugins",
			opts = {
				translucent = false,
				theme = "lackluster-dark",
				languages = { "lua" },
			},
		},
		{
			"wuz/lackluster.nvim",
			dev = true,
			lazy = false,
			priority = 1000,
			opts = function()
				local lackluster = require("lackluster")
				local color = lackluster.color
				return {
					tweak_syntax = { comment = color.gray6 },
				}
			end,
		},
		{ import = "cantrip.plugins.extras.test" },
		{ import = "cantrip.plugins.lsp.languages.lua" },
		{ import = "cantrip.plugins.lsp.languages.javascript" },
		{ import = "cantrip.plugins.lsp.languages.grit" },
		{ import = "cantrip.plugins.lsp.languages.rust" },
		{ import = "cantrip.plugins.lsp.languages.nix" },
		{ import = "cantrip.plugins.lsp.languages.markdown" },
		{ import = "cantrip.plugins.lsp.languages.python" },
		{ import = "cantrip.plugins.lsp.languages.css" },
		{ import = "cantrip.plugins.lsp.languages.swift" },
		{ import = "cantrip.plugins.lsp.languages.react" },
		{ import = "cantrip.plugins.lsp.languages.yaml" },
		{ import = "cantrip.plugins.extras.oil" },
		{ import = "cantrip.plugins.extras.fff" },
		{ import = "cantrip.plugins.extras.terminal" },
		{ import = "cantrip.plugins.extras.ai.opencode" },
		-- {
		-- 	"wuz/openpane.nvim",
		-- 	dev = true,
		-- 	opts = {},
		-- 	config = true,
		-- },
		{ import = "cantrip.plugins.extras.ai.99" },
		{ import = "cantrip.plugins.extras.miniharp" },
		{ import = "cantrip.plugins.extras.sessions" },
		{ import = "cantrip.plugins.extras.tailwind" },
		-- { import = "cantrip.plugins.extras.nvim_highlight_colors" },
		{ import = "cantrip.plugins.extras.git" },
		{ import = "cantrip.plugins.extras.worktrees" },
		{ import = "cantrip.plugins.ui.inclines.harpoon" },
		{ import = "plugins" },
	},
	defaults = { version = false },
	checker = { enabled = true },
	performance = {
		cache = { enabled = true },
		rtp = {
			disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
		},
	},
})

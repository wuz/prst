vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable bytecode cache early so every subsequent require() benefits.
vim.loader.enable()

-- ---------------------------------------------------------------------------
-- Local dev: cantrip.nvim lives on disk; add directly to rtp.
-- vim.pack only handles remote git sources, so local dev plugins use rtp.
-- ---------------------------------------------------------------------------
local cantrip_dev_path = vim.fn.expand("~/dev/github/wuz/cantrip.nvim")
if vim.uv.fs_stat(cantrip_dev_path) then
	vim.opt.rtp:prepend(cantrip_dev_path)
end

-- ---------------------------------------------------------------------------
-- Cantrip handles all plugin installation (vim.pack.add) and loading.
-- user_packs: repos not in any cantrip spec (user-local extras).
-- user_specs: additional plugin spec tables to register.
-- ---------------------------------------------------------------------------
require("cantrip").setup({
	translucent = false,
	theme = "luna",
	dev = { path = "~/dev/github/" },
	user_specs = require("plugins"),
	user_packs = {
		"https://github.com/meznaric/key-analyzer.nvim",
		"https://github.com/aserowy/tmux.nvim",
	},
	extras = {
		-- languages
		"cantrip.plugins.lsp.languages.lua",
		"cantrip.plugins.lsp.languages.javascript",
		"cantrip.plugins.lsp.languages.json",
		"cantrip.plugins.lsp.languages.go",
		"cantrip.plugins.lsp.languages.elixir",
		"cantrip.plugins.lsp.languages.grit",
		"cantrip.plugins.lsp.languages.rust",
		"cantrip.plugins.lsp.languages.nix",
		"cantrip.plugins.lsp.languages.markdown",
		"cantrip.plugins.lsp.languages.python",
		"cantrip.plugins.lsp.languages.css",
		"cantrip.plugins.lsp.languages.swift",
		"cantrip.plugins.lsp.languages.react",
		"cantrip.plugins.lsp.languages.yaml",
		-- JS/TS formatter+linter (pick one or both; remove to disable)
		-- "cantrip.plugins.extras.js.biome",
		"cantrip.plugins.extras.js.oxc",
		-- colorschemes (install both; switch active theme via the `theme` field above)
		"cantrip.plugins.extras.colors.lackluster",
		"cantrip.plugins.extras.colors.luna",
		-- extras
		"cantrip.plugins.extras.test",
		"cantrip.plugins.extras.oil",
		"cantrip.plugins.extras.fff",
		"cantrip.plugins.extras.terminal",
		"cantrip.plugins.extras.ai.opencode",
		"cantrip.plugins.extras.miniharp",
		"cantrip.plugins.extras.sessions",
		"cantrip.plugins.extras.tailwind",
		"cantrip.plugins.extras.git",
		"cantrip.plugins.extras.worktrees",
		"cantrip.plugins.extras.origami",
		"cantrip.plugins.ui.inclines.harpoon",
	},
})

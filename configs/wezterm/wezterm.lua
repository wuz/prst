local wezterm = require("wezterm")
-- local appearance = require("appearance")
local layouts = require("layouts")

local padding_h = 10
local padding_v = 10
local drag_area = 0
local tab_max_width = 50

local config = wezterm.config_builder()
config.set_environment_variables = {
	PATH = "/opt/homebrew/bin:/etc/profiles/per-user/conlin.durbin/bin:" .. os.getenv("PATH"),
}

config.swallow_mouse_click_on_window_focus = true
config.adjust_window_size_when_changing_font_size = false
config.selection_word_boundary = " \t\n{}[]()\"'`,;:@│┃*…$"
config.audible_bell = "Disabled"

local colors = {
	gray = "#1B1B1B",
	red = "#D17589",
	green = "#6A999D",
	yellow = "#b29452",
	blue = "#535d92",
	purple = "#815392",
	teal = "#538592",
	white = "#919191",
	bright_gray = "#3f3b3e",
	bright_red = "#BC566E",
	bright_green = "#87b988",
	bright_yellow = "#d0bf70",
	bright_blue = "#878fb9",
	bright_purple = "#ad87b9",
	bright_teal = "#87b9b9",
	bright_white = "#FFFFFF",
	foreground = "#E2E2E2",
	background = "#000000",
}

wezterm.on("update-right-status", function(window, pane)
	local leader = ""
	if window:leader_is_active() then
		leader = "LEADER"
	end
	local dead = ""
	if window:dead_key_is_active() then
		dead = "DEAD"
	end
	window:set_right_status(leader .. " " .. dead)
end)

config.color_schemes = {
	["sakura"] = {
		-- The default text color
		foreground = colors.foreground,
		-- The default background color
		background = colors.background,

		-- Overrides the cell background color when the current cell is occupied by the
		-- cursor and the cursor style is set to Block
		cursor_bg = colors.foreground,
		-- Overrides the text color when the current cell is occupied by the cursor
		cursor_fg = colors.background,
		-- Specifies the border color of the cursor when the cursor style is set to Block,
		-- or the color of the vertical or horizontal bar when the cursor style is set to
		-- Bar or Underline.
		cursor_border = colors.foreground,

		-- the foreground color of selected text
		selection_fg = colors.background,
		-- the background color of selected text
		selection_bg = colors.foreground,

		-- The color of the scrollbar "thumb"; the portion that represents the current viewport
		scrollbar_thumb = colors.foreground,

		-- The color of the split lines between panes
		split = colors.foreground,

		ansi = {
			colors.gray,
			colors.red,
			colors.green,
			colors.yellow,
			colors.blue,
			colors.purple,
			colors.teal,
			colors.white,
		},
		brights = {
			colors.bright_gray,
			colors.bright_red,
			colors.bright_green,
			colors.bright_yellow,
			colors.bright_blue,
			colors.bright_purple,
			colors.bright_teal,
			colors.bright_white,
		},
	},
}

config.color_scheme = "sakura"

config.font = wezterm.font_with_fallback({ "Cartograph CF", "RecMonoLinear Nerd Font" })
config.font_size = 13.5
config.line_height = 0.85
config.tab_max_width = tab_max_width

config.use_fancy_tab_bar = false
config.show_tab_index_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

config.inactive_pane_hsb = {
	brightness = 0.5,
}

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = ""
	if tab.active_pane.is_zoomed then
		zoomed = "[Z] "
	end

	local index = ""

	return zoomed .. index .. tab.active_pane.title
end)

config.default_cursor_style = "BlinkingBar"

config.window_padding = {
	left = padding_h,
	right = padding_h,
	top = padding_v + drag_area,
	bottom = padding_v,
}
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 50

-- keys
config.leader = { key = "a", mods = "SUPER", timeout_milliseconds = 1000 }
config.keys = {
	{ key = "r", mods = "SUPER|SHIFT", action = "ReloadConfiguration" },
	{
		key = "d",
		mods = "SUPER",
		action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
	},
	{
		key = "d",
		mods = "SUPER|SHIFT",
		action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
	},
	{ key = "w", mods = "SUPER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
	{ key = "LeftArrow", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "RightArrow", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	{ key = "UpArrow", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "DownArrow", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "h", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "l", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	{ key = "k", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "j", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "z", mods = "SUPER", action = "TogglePaneZoomState" },
	{
		key = '"',
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "%",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = ",",
		mods = "SUPER",
		action = wezterm.action.SpawnCommandInNewTab({
			cwd = wezterm.home_dir,
			args = { "nvim", wezterm.config_file },
		}),
	},
	{
		key = "j",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "h",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},

	{ key = "s", mods = "LEADER", action = wezterm.action_callback(layouts.serialize_window) },
	{ key = "l", mods = "LEADER", action = wezterm.action_callback(layouts.deserialize_window) },
}

wezterm.plugin.require("https://gitlab.com/xarvex/presentation.wez").apply_to_config(config, {
	presentation = {
		enabled = true,
		keybind = { key = "p", mods = "CTRL|ALT" },
		-- font_weight:          active font weight
		-- font_size_multiplier: multiplier for font size
	},
	presentation_full = {
		enabled = true,
		keybind = { key = "p", mods = "CTRL|ALT|SHIFT" },
		-- font_weight:         active font weight
		-- font_size_multipler: multiplier for font size
	},
	font_weight = "Regular", -- active font weight for both modes
	font_size_multiplier = 1.5, -- multiplier for font size for both modes
})

local plugman = require("plugman")
plugman.setup(config, {
	{
		"yriveiro/wezterm-tabs",
	},
})

return config

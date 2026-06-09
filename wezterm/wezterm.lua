local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font", weight = "Regular" },
})
config.font_size = 15.0
config.line_height = 1.0
config.cell_width = 1.0

config.font_rules = {
	{ intensity = "Bold", font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" }) },
	{ italic = true, font = wezterm.font("JetBrainsMono Nerd Font", { italic = true }) },
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold", italic = true }),
	},
}

-- Color schemes (matches the alacritty setup)
config.color_schemes = {
	["FlowDark"] = {
		background = "#1F2830",
		foreground = "#C8D0D7",
		cursor_bg = "#75BDF0",
		cursor_fg = "#1F2830",
		cursor_border = "#75BDF0",
		selection_fg = "#C8D0D7",
		selection_bg = "#2A3138",
		ansi = {
			"#1C2127",
			"#FF6B9D",
			"#7FD6A4",
			"#FFD080",
			"#75BDF0",
			"#FF007C",
			"#5CCFE6",
			"#C8D0D7",
		},
		brights = {
			"#3D4F5C",
			"#FF87B3",
			"#A1E8BE",
			"#FFE0A6",
			"#9DD3FF",
			"#FF5CA3",
			"#7FE0F0",
			"#E6EDF3",
		},
		tab_bar = {
			background = "#1F2830",
			active_tab = { bg_color = "#75BDF0", fg_color = "#1F2830" },
			inactive_tab = { bg_color = "#1F2830", fg_color = "#3D4F5C" },
			inactive_tab_hover = { bg_color = "#1C2127", fg_color = "#C8D0D7" },
			new_tab = { bg_color = "#1F2830", fg_color = "#3D4F5C" },
			new_tab_hover = { bg_color = "#1C2127", fg_color = "#C8D0D7" },
		},
	},
}
config.color_scheme = "FlowDark"

-- Window
config.window_padding = { left = 6, right = 6, top = 6, bottom = 6 }
config.window_background_opacity = 0.95
config.macos_window_background_blur = 0
config.window_decorations = "RESIZE"
config.integrated_title_buttons = {}
config.initial_rows = 50
config.initial_cols = 220

-- Tab bar (since you're moving off tmux, this replaces the tmux status bar)
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32

-- Scrollback
config.scrollback_lines = 10000

-- Misc
config.bold_brightens_ansi_colors = true
config.term = "xterm-256color"
config.audible_bell = "Disabled"
config.adjust_window_size_when_changing_font_size = false

-- Command palette styling (matches FlowDark)
config.command_palette_bg_color = "#1C2127"
config.command_palette_fg_color = "#C8D0D7"
config.command_palette_font_size = 14.0
config.command_palette_rows = 14

-- ============================================================================
-- Keybindings: tmux-style with Ctrl+Space leader
-- ============================================================================
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1500 }

-- Smart pane navigation that forwards C-h/j/k/l to nvim when nvim is focused.
-- smart-splits.nvim sets this user var and handles edge handoff back to WezTerm.
local function is_vim(pane)
	return pane:get_user_vars().IS_NVIM == "true"
end

local function smart_nav(resize_or_move, key, dir)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			elseif resize_or_move == "resize" then
				win:perform_action({ AdjustPaneSize = { dir, 3 } }, pane)
			else
				win:perform_action({ ActivatePaneDirection = dir }, pane)
			end
		end),
	}
end

config.keys = {
	-- Smart vim-aware pane navigation (replaces vim-tmux-navigator)
	smart_nav("move", "h", "Left"),
	smart_nav("move", "j", "Down"),
	smart_nav("move", "k", "Up"),
	smart_nav("move", "l", "Right"),
	smart_nav("resize", "h", "Left"),
	smart_nav("resize", "j", "Down"),
	smart_nav("resize", "k", "Up"),
	smart_nav("resize", "l", "Right"),

	-- Font size
	{ key = "0", mods = "CTRL", action = act.ResetFontSize },
	{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "+", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
	{ key = "F11", action = act.ToggleFullScreen },
	{ key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = false }) },

	-- ── tmux-style leader bindings (Ctrl+Space then key) ──
	-- Splits (open in current pane's cwd)
	{ key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- Easier split keys
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	-- Pane management
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },

	-- Tabs (tmux "windows")
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "P", mods = "LEADER|SHIFT", action = act.ActivateCommandPalette },
	{ key = "&", mods = "LEADER|SHIFT", action = act.CloseCurrentTab({ confirm = false }) },
	{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
	{ key = "6", mods = "LEADER", action = act.ActivateTab(5) },
	{ key = "7", mods = "LEADER", action = act.ActivateTab(6) },
	{ key = "8", mods = "LEADER", action = act.ActivateTab(7) },
	{ key = "9", mods = "LEADER", action = act.ActivateTab(8) },

	-- Workspaces (tmux "sessions")
	{ key = "s", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{
		key = "S",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = "New workspace name:",
			action = wezterm.action_callback(function(win, pane, line)
				if line and line ~= "" then
					win:perform_action(act.SwitchToWorkspace({ name = line }), pane)
				end
			end),
		}),
	},
	{ key = "(", mods = "LEADER|SHIFT", action = act.SwitchWorkspaceRelative(-1) },
	{ key = ")", mods = "LEADER|SHIFT", action = act.SwitchWorkspaceRelative(1) },
	{
		key = "$",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = "Rename workspace to:",
			action = wezterm.action_callback(function(win, _, line)
				if line and line ~= "" then
					wezterm.mux.rename_workspace(win:active_workspace(), line)
				end
			end),
		}),
	},

	-- Floating-ish popup: spawn a temp tab in cwd (closest equivalent to tmux popup)
	{ key = "g", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },

	-- Copy mode (tmux's prefix + [)
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "]", mods = "LEADER", action = act.PasteFrom("Clipboard") },

	-- Reload config without restart
	{ key = "r", mods = "LEADER", action = act.ReloadConfiguration },

	-- Send a literal Ctrl+Space (in case some app needs it)
	{ key = "Space", mods = "LEADER|CTRL", action = act.SendKey({ key = "Space", mods = "CTRL" }) },
}

-- Show workspace name in the tab bar's right status
wezterm.on("update-right-status", function(window)
	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "#75BDF0" } },
		{ Background = { Color = "#1C2127" } },
		{ Text = " " .. window:active_workspace() .. " " },
	}))
end)

return config

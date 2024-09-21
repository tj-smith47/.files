local wezterm = require("wezterm")

-- Mux Setup
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- Tabline Setup
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
local scheme = wezterm.color.get_builtin_schemes()["Dracula (Official)"]
local nf = wezterm.nerdfonts
local icon_overrides = {
	["elixir"] = { nf.custom_elixir, color = { fg = scheme.ansi[5] } },
	["gpg"] = { nf.cod_github, color = { fg = scheme.ansi[8] } },
	["kustomize"] = { nf.md_kubernetes, color = { fg = scheme.ansi[7] } },
	["k9s"] = { nf.md_kubernetes, color = { fg = scheme.ansi[7] } },
	["git"] = { nf.cod_github, color = { fg = scheme.ansi[8] } },
	["python"] = { nf.dev_python, color = { fg = scheme.ansi[4] } },
	["zsh"] = { nf.oct_terminal, color = { fg = scheme.ansi[7] } },
}
tabline.setup({
	options = {
		icons_enabled = true,
		theme = "Dracula (Official)",
		color_overrides = {
			normal_mode = {
				b = { fg = scheme.ansi[3] },
			},
		},
		section_separators = {
			left = nf.pl_left_hard_divider,
			right = nf.pl_right_hard_divider,
		},
		component_separators = {
			left = nf.pl_left_soft_divider,
			right = nf.pl_right_soft_divider,
		},
		tab_separators = {
			left = nf.pl_left_hard_divider,
			right = nf.pl_right_hard_divider,
		},
	},
	sections = {
		tabline_a = { "mode" },
		tabline_b = {
			{
				"workspace",
				icon = {
					wezterm.nerdfonts.dev_apple,
					color = {
						fg = scheme.ansi[6],
					},
				},
			},
		},
		tabline_c = { " " },
		tab_active = {
			"tab_index",
			{
				"process",
				padding = {
					left = 0,
					right = 1,
				},
				process_to_icon = icon_overrides,
			},
			{
				"parent",
				padding = {
					left = 1,
					right = 0,
				},
			},
			"/",
			{
				"cwd",
				max_length = 100,
				padding = {
					left = 0,
					right = 1,
				},
			},
		},
		tab_inactive = {
			{
				"tab_index",
				padding = {
					left = 0,
					right = 1,
				},
			},
			{
				"process",
				icons_only = true,
				process_to_icon = icon_overrides,
				padding = 0,
			},
			{
				"cwd",
				max_length = 50,
				padding = {
					left = 0,
					right = 1,
				},
			},
		},
		tabline_x = { "ram", "cpu" },
		tabline_y = { "datetime", "battery" },
		tabline_z = { "hostname" },
	},
	extensions = {},
})

return {
	adjust_window_size_when_changing_font_size = false,
	audible_bell = "Disabled",
	allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace",
	anti_alias_custom_block_glyphs = true,
	bold_brightens_ansi_colors = "BrightAndBold",
	color_scheme = "Dracula (Official)",
	custom_block_glyphs = true,
	default_cursor_style = "SteadyBar",
	enable_kitty_keyboard = true,
	enable_tab_bar = true,
	font = wezterm.font_with_fallback({
		{
			family = "FiraCode Nerd Font Mono",
			weight = "DemiBold",
		},
		{
			family = "Symbols Nerd Font Mono",
		},
	}),
	font_size = 15,
	hide_tab_bar_if_only_one_tab = true,
	-- initial_cols = 200,
	-- initial_rows = 50,
	keys = {
		{
			key = "DownArrow",
			mods = "ALT",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "RightArrow",
			mods = "ALT",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
	},
	native_macos_fullscreen_mode = false,
	send_composed_key_when_left_alt_is_pressed = false,
	scrollback_lines = 5000,
	use_dead_keys = false,
	window_frame = {
		font = wezterm.font({
			family = "FiraCode Nerd Font Mono",
			weight = "Bold",
		}),
	},
	tab_bar_at_bottom = true,
	tab_max_width = 150,
	text_background_opacity = 0.85,
	use_fancy_tab_bar = false,
	window_background_opacity = 0.85,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE|MACOS_FORCE_DISABLE_SHADOW",
	window_padding = {
		left = 2,
		right = 2,
		top = 8,
		bottom = 4,
	},
}

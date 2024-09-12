local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return {
	font = wezterm.font_with_fallback({
		{ family = "FiraCode Nerd Font Mono", weight = "Bold" },
		"Material Icons",
	}),
	font_size = 15,
	color_scheme = "Dracula (Official)",
	window_decorations = "RESIZE|MACOS_FORCE_DISABLE_SHADOW",
	use_fancy_tab_bar = false,
	window_background_opacity = 0.9,
	enable_tab_bar = true,
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = true,
	initial_rows = 50,
	initial_cols = 200,
	audible_bell = "Disabled",
	send_composed_key_when_left_alt_is_pressed = true,
}

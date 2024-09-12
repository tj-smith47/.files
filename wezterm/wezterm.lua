local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return {
  font = wezterm.font "FiraCode Nerd Font Mono",
  font_size = 15,
  color_scheme = 'Dracula (Official)',
  window_decorations = "RESIZE|MACOS_FORCE_DISABLE_SHADOW",
  enable_tab_bar = false,
  initial_rows = 50,
  initial_cols = 200,
  audible_bell="Disabled",
  send_composed_key_when_left_alt_is_pressed=true,
}
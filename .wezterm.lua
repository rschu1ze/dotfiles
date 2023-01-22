local wezterm = require 'wezterm'

return {
  font = wezterm.font 'Hack',
  font_size = 13,
  color_scheme = "Gruvbox Dark",
  window_close_confirmation = 'NeverPrompt',
  term = "wezterm",
  hide_tab_bar_if_only_one_tab = true,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  window_decorations = "RESIZE",
}

-- Kitty configuration:
--
-- disable_ligatures always
-- cursor_blink_interval 0
-- mouse_hide_wait -1
-- copy_on_select yes
-- enable_audio_bell no
-- visual_bell_duration 0
-- window_alert_on_bell no
-- shell_integration disabled
-- hide_window_decorations titlebar-only
-- mouse_map ctrl+left press ungrabbed mouse_selection rectangle

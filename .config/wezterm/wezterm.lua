local wezterm = require 'wezterm'

local config = {}

config = wezterm.config_builder()

-- config.term = "xterm-256color"
config.term = "wezterm"

-- config.font = wezterm.font 'Hack'
config.font = wezterm.font 'JetBrains Mono'

config.freetype_load_flags = "NO_HINTING"

config.font_size = 13.5

config.selection_word_boundary = ' \t\n{}[]()"\'`,;:│'

config.color_scheme = 'Gruvbox Dark (Gogh)'

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

config.check_for_updates = false
config.use_resize_increments = true
config.enable_tab_bar = false
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'RESIZE'

return config

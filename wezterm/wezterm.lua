-- Pull in the wezterm API
local wezterm = require 'wezterm'
local sessionizer = require 'sessionizer'
local ssh_sessionizer = require 'ssh_sessionizer'
local mux = wezterm.mux
local act = wezterm.action

-- Create configuration object
local config = wezterm.config_builder()

-- Multiplexing
-- Use unix socket by default, enabling re-entering a session after closing terminal
config.unix_domains = {{name = "unix"}}
config.default_gui_startup_args = {"connect", "unix"}

-- Appearance
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 50,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 50,
}
config.colors = {
  visual_bell = '#404040',
}
config.window_decorations = "RESIZE"
config.color_scheme = "Nord (Gogh)"
config.window_background_opacity = 0.75

config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true
config.show_close_tab_button_in_tabs = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32

config.window_frame = {
  -- The font used in the tab bar.
  -- Roboto Bold is the default; this font is bundled
  -- with wezterm.
  -- Whatever font is selected here, it will have the
  -- main font setting appended to it to pick up any
  -- fallback fonts you may have used there.
  font = wezterm.font { family = 'Hurmit Nerd Font Mono' },

  -- The size of the font in the tab bar.
  -- Default to 10.0 on Windows but 12.0 on other systems
  font_size = 12.0,
}

-- Keybinds
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  { key = "L", mods = "LEADER", action = act.ShowLauncher },
  { key = "f", mods = "LEADER", action = wezterm.action_callback(sessionizer.toggle) },
  { key = "c", mods = "LEADER", action = wezterm.action_callback(sessionizer.cheatsh) },
  { key = "s", mods = "LEADER", action = wezterm.action_callback(ssh_sessionizer.connect) },
  { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "t", mods = "CTRL", action = act.SpawnTab "CurrentPaneDomain" },
  { key = "x", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "Q", mods = "LEADER", action = act.QuitApplication },
  { key = "v", mods = "LEADER", action = act.SplitPane { direction = "Right" }, },
  { key = "b", mods = "LEADER", action = act.SplitPane { direction = "Down" }, },
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection 'Left' },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection 'Down' },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection 'Up' },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection 'Right' },
  { key = "H", mods = "CTRL", action = act.AdjustPaneSize { 'Left', 5 }, },
  { key = "J", mods = "CTRL", action = act.AdjustPaneSize { 'Down', 5 }, },
  { key = "K", mods = "CTRL", action = act.AdjustPaneSize { 'Up', 5 }, },
  { key = "L", mods = "CTRL", action = act.AdjustPaneSize { 'Right', 5 }, },
}

for i=1,9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1)
  })
end

-- and finally, return the configuration to wezterm
return config

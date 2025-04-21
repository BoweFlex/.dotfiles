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
config.color_scheme = 'Ashes (dark) (terminal.sexy)'
config.window_background_opacity = 0.6

config.hide_tab_bar_if_only_one_tab = false

-- Keybinds
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  { key = 'l', mods = "LEADER", action = act.ShowLauncher },
  { key = 'f', mods = "LEADER", action = wezterm.action_callback(sessionizer.toggle) },
  { key = 's', mods = "LEADER", action = wezterm.action_callback(ssh_sessionizer.toggle) },
  { key = 'p', mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = 'n', mods = "LEADER", action = act.ActivateTabRelative(1) },
  -- Add copy mode and split/resize binds
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

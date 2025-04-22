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
config.window_background_opacity = 0.7

config.hide_tab_bar_if_only_one_tab = false

-- Keybinds
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  { key = "l", mods = "LEADER", action = act.ShowLauncher },
  { key = "f", mods = "LEADER", action = wezterm.action_callback(sessionizer.toggle) },
  { key = "c", mods = "LEADER", action = wezterm.action_callback(sessionizer.cheatsh) },
  { key = "s", mods = "LEADER", action = wezterm.action_callback(ssh_sessionizer.connect) },
  { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "N", mods = "LEADER", action = act.SpawnTab "CurrentPaneDomain" },
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

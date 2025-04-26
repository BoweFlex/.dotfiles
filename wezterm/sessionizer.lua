local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local fd = "/usr/bin/fd"

function workspace_exists(name)
  for _, value in pairs(wezterm.mux.get_workspace_names()) do
    if value == name then
      return true
    end
  end
  return false
end

M.toggle = function(window, pane)
	local projects = {}

	local success, stdout, stderr = wezterm.run_child_process({
		fd,
		"-HI",
		"^.git$",
		"--max-depth=6",
		"--prune",
		wezterm.home_dir -- .. "/boweflex"
	})

	if not success then
		wezterm.log_error("Failed to run fd: " .. stderr)
		return
	end

	-- List git directories
	for line in stdout:gmatch("([^\n]*)\n?") do
		local project = line:gsub("/.git.*$", "")
		local label = project
		local id = project:gsub(".*/", "")
		table.insert(projects, { label = tostring(label), id = tostring(id) })
	end

	-- List current workspaces
	for _, value in pairs(wezterm.mux.get_workspace_names()) do
		table.insert(projects, { label = tostring(value), id = tostring(value) })
	end

	-- Create action to list projects and either
	-- create a new workspace with my editor and terminal or 
	-- switch to the existing workspace
	window:perform_action(
		act.InputSelector({
			action = wezterm.action_callback(function(win, _, id, label)
				if not id and not label then
					wezterm.log_info("Cancelled")
				else
					wezterm.log_info("Selected " .. label)
					if workspace_exists(id) then
						win:perform_action(act.SwitchToWorkspace {
							name = id,
						}, pane)
					else
						-- Create a new workspace with terminal open
						win:perform_action(act.SwitchToWorkspace {
							name = id,
							spawn = { cwd = label }
						}, pane)
						wezterm.sleep_ms(25) -- needed for editor to open in new workspace
						-- Create another tab with Editor open
						win:perform_action(act.SpawnCommandInNewTab {
					    cwd = label,
					    args = { "hx", "." },
					  }, pane)
					end
				end
			end),
			fuzzy = true,
			title = "Select project",
			choices = projects,
		}),
		pane
	)
end

M.cheatsh = function(window, pane)
  local workspace = "cheatsheet"
	-- Create action to accept input and then open a new tab in the
	-- "cheatsheet" workspace with the arg `curl cheat.sh/<input>`
	window:perform_action(
		act.PromptInputLine({
			description = "Enter the command you would like a cheatsheet for, replacing ' ' with '-'.",
			action = wezterm.action_callback(function(win, pane, line)
				local cmd = "curl -s 'cheat.sh/" .. line .. "?T' | less"
				if workspace_exists(workspace) then
					win:perform_action(act.SwitchToWorkspace {
						name = workspace,
					}, pane)
					wezterm.sleep_ms(25) -- needed for cheatsheet to open in correct workspace
					-- Create another tab new cheatsheet open
					win:perform_action(act.SpawnCommandInNewTab {
						label = line,
				    args = { "zsh", "-c", cmd },
				  }, pane)
				else
					win:perform_action(act.SwitchToWorkspace {
						name = workspace,
						spawn = {
							label = line,
					    args = { "zsh", "-c", cmd },
						},
					}, pane)
				end
			end),
		}),
		pane
	)
end

return M

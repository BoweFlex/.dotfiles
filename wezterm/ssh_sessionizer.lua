local wezterm = require("wezterm")
local act = wezterm.action

local S = {}

function workspace_exists(name)
  for _, value in pairs(wezterm.mux.get_workspace_names()) do
    if value == name then
      return true
    end
  end
  return false
end

S.toggle = function(window, pane)
	local hosts = {}

	local f = assert(io.open(wezterm.home_dir .. "/.ssh/known_hosts"))
	if f then
  	local known_hosts = f:read("*all")
  	f:close()
    for _, line in ipairs(wezterm.split_by_newlines(known_hosts)) do
      for host in line:gmatch("%S+") do
    	  table.insert(hosts, { label = host, id = host})
    	  break
    	end
  	end
  end


	-- Create action to list hosts and create ssh session with selection
	window:perform_action(
		act.InputSelector({
			action = wezterm.action_callback(function(win, _, id, label)
				if not id and not label then
					wezterm.log_info("Cancelled")
				else
					wezterm.log_info("Selected " .. label)
					win:perform_action(act.SwitchToWorkspace {
            name = label,
            spawn = {
               args = { 'ssh', label },
            }
          }, pane)
				end
			end),
			fuzzy = true,
			title = "Enter Hostname to SSH into",
			choices = hosts,
		}),
		pane
	)
end
S.connect = function(window, pane)
	-- Create action to accept input and create a workspace for the hostname provided
	window:perform_action(
		act.PromptInputLine({
			description = "Enter the hostname you'd like to connect to.",
			action = wezterm.action_callback(function(win, pane, line)
				local host = "ssh " .. line
				if workspace_exists(host) then
					win:perform_action(act.SwitchToWorkspace {
						name = host,
					}, pane)
				else
					win:perform_action(act.SwitchToWorkspace {
						name = host,
						spawn = {
							label = url,
					    args = { "ssh", "-q", line },
						},
					}, pane)
				end
			end),
		}),
		pane
	)
end

return S

local wezterm = require("wezterm")

local PM = {}

local function startsWith(string, start)
	return string:find("^" .. start) ~= nil
end

PM.setup = function(wezterm_config, plugman_config)
	if type(plugman_config) == "table" then
		for k, v in pairs(plugman_config) do
			local opts = v["opts"]
			local url = v[1]
			if not startsWith(url, "^https://") then
				url = "https://github.com/" .. url
			end
			wezterm.plugin.require(url).apply_to_config(wezterm_config, opts)
		end
	end
end

return PM

local wezterm = require("wezterm")
local act = wezterm.action
local module = {}

local function write_layout(name, window_config)
  local file = io.open(wezterm.config_dir .. "/layouts/" .. name .. ".json", "w")
  if file then
    file:write(wezterm.json_encode(window_config))
    file:close()
  end
end

local function get_layouts()
  local layout_files = io.popen("ls " .. wezterm.config_dir .. "/layouts")

  if layout_files then
    local lines = {}
    for line in layout_files:lines() do
      local layout = string.gsub(line, ".json$", "")
      table.insert(lines, layout)
    end
    layout_files:close()
    return lines
  end
end

function module.serialize_window(current_window, current_pane)
  local window_config = {}
  for i_tab, tab in pairs(current_window:mux_window():tabs()) do
    window_config[i_tab] = {}

    for j_pane, pane in pairs(tab:panes()) do
      local user_vars = pane:get_user_vars()

      local prog = user_vars.WEZTERM_PROG
      if prog == "" then
        prog = nil
      end

      local cwd = user_vars.WEZTERM_CWD
      if cwd == "" or cwd == nil then
        cwd = pane:get_foreground_process_info().cwd
      end

      window_config[i_tab][j_pane] = {
        prog = prog,
        cwd = cwd,
      }
    end
  end

  local saved_layouts = ""
  for _, layout in pairs(get_layouts()) do
    saved_layouts = saved_layouts .. "  " .. layout .. "\n"
  end

  current_window:perform_action(
    act.PromptInputLine({
      description = "Saved layouts:\n\n" .. saved_layouts .. "\nEnter name for this layout:",
      action = wezterm.action_callback(function(_, _, line)
        if line then
          write_layout(line, window_config)
        end
      end),
    }),
    current_pane
  )
end

local function send_prog(pane, pane_config)
  if pane_config.prog then
    pane:send_text(pane_config.prog .. "\n")
  end
end

local function load_other_panes(original_pane, tab_config)
  for j, new_pane_config in pairs(tab_config) do
    if j ~= 1 then
      local _, new_pane, _ = original_pane:split({ cwd = new_pane_config.cwd })
      send_prog(new_pane, new_pane_config)
    end
  end
end

local function load_window(filename)
  local file = io.open(wezterm.config_dir .. "/layouts/" .. filename .. ".json", "r")
  if file then
    local window_config = wezterm.json_parse(file:read())
    file:close()

    local first_tab_config = window_config[1]
    local first_pane_config = first_tab_config[1]

    local _, first_pane, window = wezterm.mux.spawn_window({
      cwd = first_pane_config.cwd,
    })
    send_prog(first_pane, first_pane_config)
    load_other_panes(first_pane, first_tab_config)

    for i, tab_config in pairs(window_config) do
      if i ~= 1 then
        local _, pane, _ = window:spawn_tab({
          cwd = tab_config[1].cwd,
        })
        send_prog(pane, tab_config[1])

        load_other_panes(pane, tab_config)
      end
    end
  end
end

function module.deserialize_window(current_window, current_pane)
  local choices = {}
  for _, layout_file in pairs(get_layouts()) do
    table.insert(choices, { label = layout_file })
  end

  current_window:perform_action(
    act.InputSelector({
      action = wezterm.action_callback(function(_, _, _, layout)
        if layout then
          load_window(layout)
        end
      end),
      title = "Load layout:",
      choices = choices,
    }),
    current_pane
  )
end

return module

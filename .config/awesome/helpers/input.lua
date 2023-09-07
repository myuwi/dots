local awful = require("awful")

local _M = {}

--- @param device_name string Device Name in `xinput list`.
--- @param device_index? number Index of the device in `xinput list`. Devices are sorted in ascending order based on their id. Index can be negative to count back from the end of the device list.
--- @return number|nil
_M.get_device_id = function(device_name, device_index)
  if not device_index or device_index == 0 then
    device_index = 1
  end

  local out_stream = io.popen([[xinput list | grep ']] .. device_name .. [[' | sed -e 's/^.*id=\([0-9]*\).*$/\1/g']])

  if not out_stream then
    return nil
  end

  local ids = {}
  local i = 0
  for line in out_stream:lines() do
    local id = tonumber(line)
    if id then
      i = i + 1
      ids[i] = id
    end
  end
  out_stream:close()

  table.sort(ids)

  if math.abs(device_index) > #ids then
    return nil
  end

  if device_index > 0 then
    return ids[device_index]
  elseif device_index < 0 then
    return ids[#ids + 1 + device_index]
  end

  return nil
end

--- Fake key down events
_M.key_down = function(keys)
  awful.spawn("xdotool keydown " .. keys)
end

--- Fake key up events
_M.key_up = function(keys)
  awful.spawn("xdotool keyup " .. keys)
end

--- Fake key press events
--- @param keys string
--- @param modifiers integer[]? Modifier keys to release and restore before and after pressing keys
_M.key = function(keys, modifiers)
  if not modifiers or #modifiers == 0 then
    awful.spawn("xdotool key " .. keys)
    return
  end

  local keyboard_name = user_vars.keyboard_name or ""

  local mods = table.concat(modifiers, " ")

  local script = [[
    xdotool keyup ]] .. mods .. [[ &&
    xdotool key ]] .. keys .. [[ &&
    xdotool keydown ]] .. mods .. [[ &&
    restore-mods ']] .. keyboard_name .. [['
  ]]

  awful.spawn.with_shell(script)
end

_M.fcitx_toggle = function()
  awful.spawn("fcitx5-remote -t")
end

--- @param callback fun(id: integer|nil)
_M.fcitx_status = function(callback)
  awful.spawn.easy_async("fcitx5-remote", function(mode)
    callback(tonumber(mode))
  end)
end

return _M

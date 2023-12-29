local awful = require("awful")

local _M = {}

--- Fake key down events
_M.key_down = function(keys)
  awful.spawn("xdotool keydown " .. keys, false)
end

--- Fake key up events
_M.key_up = function(keys)
  awful.spawn("xdotool keyup " .. keys, false)
end

--- Fake key press events
--- @param keys string
--- @param modifiers integer[]? Modifier keys to release and restore before and after pressing keys
_M.key = function(keys, modifiers)
  if not modifiers or #modifiers == 0 then
    awful.spawn("xdotool key " .. keys, false)
    return
  end

  local mods = table.concat(modifiers, " ")

  local script = [[
    xdotool keyup ]] .. mods .. [[ &&
    xdotool key ]] .. keys .. [[ &&
    xdotool keydown ]] .. mods .. [[ &&
    restore-mods
  ]]

  awful.spawn.with_shell(script)
end

_M.fcitx_toggle = function()
  awful.spawn("fcitx5-remote -t", false)
end

--- @param callback fun(id: integer|nil)
_M.fcitx_status = function(callback)
  awful.spawn.easy_async("fcitx5-remote", function(mode)
    callback(tonumber(mode))
  end)
end

return _M

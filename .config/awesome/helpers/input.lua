local awful = require("awful")

local _M = {}

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
  if not modifiers then
    awful.spawn("xdotool key " .. keys)
    return
  end

  local keyboard_id = 18

  local _mods = table.concat(modifiers, " ")
  local _mods_grep = _mods:gsub(" ", "|")

  local script = [[
    xdotool keyup ]] .. _mods .. [[ &&
    xdotool key ]] .. keys .. [[ &&
    xdotool keydown ]] .. _mods .. [[ &&
    xinput query-state ]] .. keyboard_id .. [[ |
    grep -E 'key\[(]] .. _mods_grep .. [[)\]=up' |
    sed -rze 's/[^0-9]+/ /g' |
    xargs -r xdotool keyup
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

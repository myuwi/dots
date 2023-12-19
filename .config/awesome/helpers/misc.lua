local awful = require("awful")

local _M = {}

--- Take a screenshot
--- @param padding number
_M.take_screenshot = function(padding)
  local draw_bg = padding > 0 and "-B" or ""

  local script = ("maim -su -p %s %s | xclip -sel clip -t image/png"):format(padding, draw_bg)

  awful.spawn.with_shell(script)
end

_M.command_exists = function(command, callback)
  awful.spawn.easy_async_with_shell("command -v " .. command, function(_, _, _, exitcode)
    callback(exitcode == 0)
  end)
end

return _M

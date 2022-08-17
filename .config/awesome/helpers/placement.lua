local awful = require("awful")

local _M = {}

_M.centered = function(c)
  awful.placement.centered(c, {
    -- Let fullscreen windows spawn at the true center of the screen
    honor_workarea = not c.fullscreen,
  })
end

return _M

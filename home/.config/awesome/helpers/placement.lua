local awful = require("awful")

local M = {}

function M.centered(c)
  awful.placement.centered(c, {
    -- Let fullscreen windows spawn at the true center of the screen
    honor_workarea = not c.fullscreen,
  })
end

return M

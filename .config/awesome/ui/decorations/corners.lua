local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")
local rounded_shape = helpers.shape.rounded_rect(beautiful.border_radius)

local function toggle_rounded_corners(c)
  if c.fullscreen or c.maximized then
    c.shape = gears.shape.rectangle
  else
    c.shape = rounded_shape
  end
end

client.connect_signal("manage", toggle_rounded_corners)
client.connect_signal("property::fullscreen", toggle_rounded_corners)
client.connect_signal("property::maximized", toggle_rounded_corners)

beautiful.snap_shape = helpers.shape.rounded_rect(beautiful.border_radius * 2)

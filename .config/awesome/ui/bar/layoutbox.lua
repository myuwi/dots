local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local layoutbox = function(s)
  local layoutbox_widget = wibox.widget({
    {
      {
        widget = awful.widget.layoutbox(s),
        forced_height = dpi(24),
        forced_width = dpi(24),
      },
      margins = dpi(4),
      widget = wibox.container.margin,
    },
    widget = wibox.container.place,
  })

  layoutbox_widget:buttons({
    awful.button({}, 1, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 3, function()
      awful.layout.inc(-1)
    end),
    awful.button({}, 4, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 5, function()
      awful.layout.inc(-1)
    end),
  })

  return layoutbox_widget
end

return layoutbox

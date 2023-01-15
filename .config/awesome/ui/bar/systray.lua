local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

local systray = function()
  local widget_systray = wibox.widget({
    {
      {
        {
          screen = screen.primary,
          widget = wibox.widget.systray,
        },
        margins = dpi(8),
        widget = wibox.container.margin,
      },
      widget = wibox.container.place,
    },
    bg = beautiful.bg_systray,
    shape = gears.shape.rounded_bar,
    widget = wibox.container.background,
  })

  return widget_systray
end

return systray
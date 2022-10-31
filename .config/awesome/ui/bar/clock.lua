local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local clock = function()
  local widget_clock = wibox.widget({
    {
      {
        format = "%a %d %b %H:%M",
        widget = wibox.widget.textclock,
      },
      widget = wibox.container.place,
    },
    margins = dpi(6),
    widget = wibox.container.margin,
  })

  return widget_clock
end

return clock

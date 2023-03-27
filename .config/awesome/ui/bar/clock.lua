local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local clock = function()
  local clock_widget = wibox.widget({
    {
      {
        format = "%a %d %b %H:%M",
        widget = wibox.widget.textclock,
      },
      widget = wibox.container.place,
    },
    margins = dpi(8),
    widget = wibox.container.margin,
  })

  return clock_widget
end

return clock

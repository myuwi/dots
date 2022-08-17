local wibox = require("wibox")

local clock = function()
  local widget = wibox.widget({
    {
      format = "%a %d %b %H:%M",
      widget = wibox.widget.textclock,
    },
    widget = wibox.container.place,
  })

  return widget
end

return clock

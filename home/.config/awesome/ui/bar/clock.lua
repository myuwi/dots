local awful = require("awful")
local wibox = require("wibox")

local clock = function()
  local clock_buttons = {
    awful.button({}, 1, function()
      awesome.emit_signal("widgets::time_and_date::show")
    end),
  }

  local clock_widget = wibox.widget({
    {
      format = "%a %d %b %H:%M",
      widget = wibox.widget.textclock,
    },
    buttons = clock_buttons,
    widget = wibox.container.place,
  })

  return clock_widget
end

return clock

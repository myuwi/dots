local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local systray = function(s)
  local widget_systray = wibox.widget({
    {
      screen = screen.primary,
      widget = wibox.widget.systray,
      base_size = dpi(20),
    },
    visible = s == screen.primary,
    widget = wibox.container.place,
  })

  return widget_systray
end

return systray

local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local systray = function()
  local widget_systray = wibox.widget({
    {
      screen = screen.primary,
      widget = wibox.widget.systray,
      bg = beautiful.bg_panel,
    },
    margins = dpi(10),
    widget = wibox.container.margin,
  })

  return widget_systray
end

return systray

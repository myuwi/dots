local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local systray = function()
  local widget = wibox.widget({
    {
      screen = screen.primary,
      widget = wibox.widget.systray,
      bg = beautiful.bg_panel,
    },
    margins = 10,
    widget = wibox.container.margin,
  })

  return widget
end

return systray

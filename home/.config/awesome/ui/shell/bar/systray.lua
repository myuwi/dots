local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local function systray()
  local systray_widget = wibox.widget({
    {
      screen = screen.primary,
      base_size = dpi(16),
      widget = wibox.widget.systray,
    },
    valign = "center",
    widget = wibox.container.place,
  })

  return systray_widget
end

return systray

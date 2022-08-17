local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

awful.screen.connect_for_each_screen(function(s)
  local panel = awful.wibar({
    position = "top",
    screen = s,
    height = dpi(42),
    bg = beautiful.bg_panel,
    widget = {
      require("ui.panel.taglist")(s),
      require("ui.panel.tasklist")(s),
      {
        {
          require("ui.panel.systray")(s),
          require("ui.panel.clock")(),
          require("ui.panel.layoutbox")(s),
          spacing = dpi(8),
          layout = wibox.layout.fixed.horizontal,
        },
        left = dpi(16),
        widget = wibox.container.margin,
      },
      layout = wibox.layout.align.horizontal,
    },
  })
end)

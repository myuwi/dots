local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

screen.connect_signal("request::desktop_decoration", function(s)
  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  -- Create the panel
  local panel = awful.wibar({
    position = "top",
    screen = s,
    height = dpi(40),
    bg = beautiful.bg_panel,
  })

  -- Add widgets to the panel
  panel:setup({
    require("ui.panel.taglist")(s),
    require("ui.panel.tasklist")(s),
    {
      require("ui.panel.systray")(),
      require("ui.panel.clock")(),
      require("ui.panel.layoutbox")(s),
      layout = wibox.layout.fixed.horizontal,
    },
    layout = wibox.layout.align.horizontal,
  })
end)

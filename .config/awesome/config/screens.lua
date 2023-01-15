local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

tag.connect_signal("request::default_layouts", function()
  awful.layout.append_default_layouts({
    awful.layout.suit.tile,
    awful.layout.suit.max,
  })
end)

screen.connect_signal("request::desktop_decoration", function(s)
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
end)

screen.connect_signal("request::wallpaper", function(s)
  if beautiful.wallpaper then
    gears.wallpaper.maximized(beautiful.wallpaper, s)
  end
end)

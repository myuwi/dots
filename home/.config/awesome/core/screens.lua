local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

tag.connect_signal("request::default_layouts", function()
  awful.layout.append_default_layouts({
    -- TODO: Let client only occupy master, even if stack is empty
    awful.layout.suit.tile,
    awful.layout.suit.max,
  })
end)

screen.connect_signal("request::desktop_decoration", function(s)
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
end)

screen.connect_signal("request::wallpaper", function(s)
  if beautiful.wallpaper then
    local geo = s.geometry

    awful.wallpaper({
      screen = s,
      widget = {
        image = gears.surface.crop_surface({
          ratio = geo.width / geo.height,
          surface = gears.surface.load_uncached(beautiful.wallpaper),
        }),
        widget = wibox.widget.imagebox,
      },
    })
  end
end)

local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

tag.connect_signal("request::default_layouts", function()
  awful.layout.append_default_layouts({
    awful.layout.suit.tile,
    awful.layout.suit.max,
  })
end)

screen.connect_signal("request::wallpaper", function(s)
  if beautiful.wallpaper then
    gears.wallpaper.maximized(beautiful.wallpaper, s)
  end
end)

client.connect_signal("manage", function(c, context)
  if not awesome.startup then
    awful.client.setslave(c)

    -- Center floating windows when they are spawned
    if c.floating then
      awful.placement.centered(c)
    end
  end

  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

require("config.autostart")
require("config.keybinds")
require("config.monitors")
require("config.rules")

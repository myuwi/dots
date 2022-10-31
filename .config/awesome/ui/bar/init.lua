local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local taglist = require("ui.bar.taglist")
local tasklist = require("ui.bar.tasklist")
local systray = require("ui.bar.systray")
local clock = require("ui.bar.clock")
-- local layoutbox = require("ui.bar.layoutbox")

awful.screen.connect_for_each_screen(function(s)
  local is_primary = s == screen.primary

  awful.wibar({
    position = "top",
    screen = s,
    height = beautiful.bar_height,
    bg = beautiful.bg_bar,
    widget = {
      {
        taglist(s),
        {
          tasklist(s),
          left = beautiful.bar_spacing,
          right = beautiful.bar_spacing,
          widget = wibox.container.margin,
        },
        {
          is_primary and systray() or nil,
          clock(),
          spacing = beautiful.bar_spacing,
          layout = wibox.layout.fixed.horizontal,
        },
        layout = wibox.layout.align.horizontal,
      },
      margins = beautiful.bar_padding,
      widget = wibox.container.margin,
    },
  })
end)

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
  local bar_margin = beautiful.bar_gap
  local bar_position = beautiful.bar_position

  awful.wibar({
    position = bar_position,
    screen = s,
    height = beautiful.bar_height,
    width = beautiful.bar_width,
    bg = beautiful.bg_bar,
    margins = {
      top = bar_position == "top" and bar_margin or 0,
      left = bar_margin,
      right = bar_margin,
      bottom = bar_position == "bottom" and bar_margin or 0,
    },
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

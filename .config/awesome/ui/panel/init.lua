local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local taglist = require("ui.panel.taglist")
local tasklist = require("ui.panel.tasklist")
local systray = require("ui.panel.systray")
local clock = require("ui.panel.clock")
-- local layoutbox = require("ui.panel.layoutbox")

awful.screen.connect_for_each_screen(function(s)
  local is_primary = s == screen.primary

  local panel = awful.wibar({
    position = "top",
    screen = s,
    height = dpi(46),
    bg = beautiful.bg_panel,
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

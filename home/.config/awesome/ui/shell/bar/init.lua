local awful = require("awful")
local beautiful = require("beautiful")

local Window = require("ui.window")
local Container = require("ui.widgets").Container
local Row = require("ui.widgets").Row
local RowAlign = require("ui.widgets").RowAlign

local taglist = require("ui.shell.bar.taglist")
local tasklist = require("ui.shell.bar.tasklist")
local systray = require("ui.shell.bar.systray")
local battery = require("ui.shell.bar.battery")
local clock = require("ui.shell.bar.clock")

awful.screen.connect_for_each_screen(function(s)
  local is_primary = s == screen.primary
  local bar_margin = beautiful.bar_gap
  local bar_position = beautiful.bar_position

  s.bar = Window {
    window = awful.wibar,
    screen = s,
    position = bar_position,
    bg = beautiful.colors.transparent,
    height = beautiful.bar_height,
    width = beautiful.bar_width,
    margins = {
      top = bar_position == "top" and bar_margin or 0,
      left = bar_margin,
      right = bar_margin,
      bottom = bar_position == "bottom" and bar_margin or 0,
    },

    Container {
      bg = beautiful.bg_bar,
      border_color = beautiful.border_color,
      border_width = beautiful.border_width,
      radius = beautiful.border_radius,
      padding = beautiful.bar_padding,

      RowAlign {
        taglist(s),
        Container {
          padding = { x = beautiful.bar_spacing },
          tasklist(s),
        },
        Row {
          spacing = beautiful.bar_spacing,
          is_primary and systray() or nil,
          battery(),
          clock(s),
        },
      },
    },
  }
end)

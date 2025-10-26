local awful = require("awful")
local beautiful = require("beautiful")

local Window = require("ui.window")
local Container = require("ui.widgets").Container
local Flexible = require("ui.widgets").Flexible
local Row = require("ui.widgets").Row

local taglist = require("ui.shell.bar.taglist")
local tasklist = require("ui.shell.bar.tasklist")
local systray = require("ui.shell.bar.systray")
local battery = require("ui.shell.bar.battery")
local clock = require("ui.shell.bar.clock")

awful.screen.connect_for_each_screen(function(s)
  local is_primary = s == screen.primary
  local bar_gap = beautiful.useless_gap * 2
  local bar_position = beautiful.bar_position

  s.bar = Window {
    window = awful.wibar,
    screen = s,
    position = bar_position,
    bg = beautiful.colors.transparent,
    height = beautiful.bar_height,
    margins = { top = bar_gap, left = bar_gap, right = bar_gap, bottom = 0 },

    Container {
      bg = beautiful.bg_bar,
      border_color = beautiful.border_color,
      border_width = beautiful.border_width,
      radius = beautiful.border_radius,
      padding = beautiful.bar_padding,

      Row {
        spacing = beautiful.bar_spacing,
        taglist(s),
        Flexible {
          grow = 1,
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

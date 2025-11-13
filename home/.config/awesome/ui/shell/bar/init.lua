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
local status = require("ui.shell.bar.status")
local clock = require("ui.shell.bar.clock")

awful.screen.connect_for_each_screen(function(s)
  local is_primary = s == screen.primary
  local bar_gap = beautiful.useless_gap * 2

  s.bar = Window {
    window = awful.wibar,
    screen = s,
    height = beautiful.bar_height,
    margins = { top = bar_gap, left = bar_gap, right = bar_gap, bottom = 0 },
    bg = beautiful.bg_bar,
    radius = beautiful.corner_radius,

    Container {
      padding = beautiful.bar_padding,

      Row {
        spacing = beautiful.bar_spacing,
        taglist(s),
        Flexible {
          grow = 1,
          tasklist(s),
        },
        Row {
          spacing = beautiful.bar_spacing / 2,
          is_primary and systray() or nil,
          is_primary and battery() or nil,
          is_primary and status() or nil,
          clock(s),
        },
      },
    },
  }
end)

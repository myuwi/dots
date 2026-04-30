local awful = require("awful")
local beautiful = require("beautiful")

local Window = require("tide.core.window")
local Container = require("tide.widget").Container
local Flexible = require("tide.widget").Flexible
local Row = require("tide.widget").Row

local taglist = require("ui.shell.bar.modules.taglist")
local tasklist = require("ui.shell.bar.modules.tasklist")
local systray = require("ui.shell.bar.modules.systray")
local quick_settings = require("ui.shell.bar.modules.quick_settings")
local clock = require("ui.shell.bar.modules.clock")

awful.screen.connect_for_each_screen(function(s)
  local is_primary = s == screen.primary
  local bar_gap = beautiful.useless_gap

  s.bar = Window {
    window = awful.wibar,
    screen = s,
    height = beautiful.bar_height,
    bg = "transparent",
    margins = { top = bar_gap, bottom = -bar_gap },

    Container {
      padding = { x = beautiful.bar_padding * 2, y = beautiful.bar_padding },

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
          is_primary and quick_settings() or nil,
          clock(s),
        },
      },
    },
  }
end)

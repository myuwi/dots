local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local signal = require("ui.core.signal")
local computed = require("ui.core.signal.computed")
local bind = require("ui.core.signal.bind")

local Container = require("ui.widgets").Container
local Row = require("ui.widgets").Row
local Text = require("ui.widgets").Text

local tbl = require("helpers.table")

local function taglist_buttons(t)
  return {
    awful.button({}, 1, function()
      t:view_only()
    end),
    awful.button({ modkey }, 1, function()
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end),
    awful.button({}, 3, function()
      awful.tag.viewtoggle(t)
    end),
  }
end

local function taglist(s)
  local taglist_widget = Row {
    spacing = dpi(4),
    on_wheel_up = function()
      awful.tag.viewnext(s)
    end,
    on_wheel_down = function()
      awful.tag.viewprev(s)
    end,

    tbl.map(s.tags, function(t)
      local selected = bind(t, "selected")
      local urgent = bind(t, "urgent")
      local client_count = signal(0)

      t:connect_signal("tagged", function()
        client_count:set(#t:clients())
      end)

      t:connect_signal("untagged", function()
        client_count:set(#t:clients())
      end)

      return Container {
        bg = computed(function()
          return selected:get() and beautiful.bg_focus or urgent:get() and beautiful.bg_urgent or nil
        end),
        border_width = 1,
        border_color = computed(function()
          return selected:get() and beautiful.border_focus or beautiful.colors.transparent
        end),
        visible = computed(function()
          return selected:get() or client_count:get() > 0
        end),
        radius = dpi(4),
        forced_width = dpi(20),
        buttons = taglist_buttons(t),

        Text {
          text = t.index,
          halign = "center",
        },
      }
    end),
  }

  return taglist_widget
end

return taglist

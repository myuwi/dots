local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local hcolor = require("helpers.color")

local signal = require("tide.signal")
local computed = require("tide.signal.computed")
local watch = require("tide.signal.watch")

local Container = require("tide.widget").Container
local Row = require("tide.widget").Row
local Text = require("tide.widget").Text

local tag_transition = require("core.tag_transition")
local tbl = require("helpers.table")

local function taglist_buttons(t)
  return {
    awful.button({}, 1, function()
      tag_transition.view_only(t)
    end),
    awful.button({ modkey }, 1, function()
      if client.focus then
        tag_transition.move_to_tag(client.focus, t)
      end
    end),
    awful.button({}, 3, function()
      tag_transition.view_toggle(t)
    end),
  }
end

local function taglist(s)
  local taglist_widget = Row {
    spacing = dpi(6),
    on_wheel_up = function()
      tag_transition.view_next(s)
    end,
    on_wheel_down = function()
      tag_transition.view_prev(s)
    end,

    tbl.map(s.tags, function(t)
      local selected = watch(t, "selected")
      -- TODO: local urgent = watch(t, "urgent")
      local client_count = signal(0)

      t:connect_signal("tagged", function()
        client_count:set(#t:clients())
      end)

      t:connect_signal("untagged", function()
        client_count:set(#t:clients())
      end)

      return Container {
        visible = computed(function()
          return selected:get() or client_count:get() > 0
        end),
        radius = dpi(4),
        forced_width = dpi(24),
        buttons = taglist_buttons(t),

        opacity = computed(function()
          return selected:get() and 1 or 0.5
        end),

        Text {
          shadow = { x = 1, y = 1, blur = 8, color = hcolor.opacity("#000000", 0.6) },
          halign = "center",
          t.index,
        },
      }
    end),
  }

  return taglist_widget
end

return taglist

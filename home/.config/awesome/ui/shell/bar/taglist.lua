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
  local tags = tbl.map(s.tags, function(t)
    local client_count = signal(0)

    t:connect_signal("tagged", function()
      client_count.value = #t:clients()
    end)
    t:connect_signal("untagged", function()
      client_count.value = #t:clients()
    end)

    return client_count
  end)

  local taglist_widget = Row {
    spacing = dpi(4),
    on_wheel_up = function()
      awful.tag.viewnext(s)
    end,
    on_wheel_down = function()
      awful.tag.viewprev(s)
    end,

    children = tbl.map(s.tags, function(t, i)
      local selected = bind(t, "selected")
      local urgent = bind(t, "urgent")

      return Container {
        bg = computed(function()
          return selected.value and beautiful.bg_focus or urgent.value and beautiful.bg_urgent or nil
        end),
        visible = computed(function()
          return selected.value or tags[i].value > 0
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

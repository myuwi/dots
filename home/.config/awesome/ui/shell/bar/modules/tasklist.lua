local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local signal = require("lib.signal")
local computed = require("lib.signal.computed")
local bind = require("lib.signal.bind")

local Container = require("ui.widgets").Container
local Flexible = require("ui.widgets").Flexible
local ClientIcon = require("ui.widgets").ClientIcon
local Row = require("ui.widgets").Row
local Text = require("ui.widgets").Text

local tbl = require("helpers.table")
local throttle = require("helpers.fn").throttle

local function get_clients(s)
  local clients = client.get()
  clients = tbl.filter(clients, function(c)
    return not (c.skip_taskbar or c.hidden or c.type == "splash" or c.type == "dock" or c.type == "desktop")
      and awful.widget.tasklist.filter.currenttags(c, s)
  end)

  return clients
end

local function tasklist_buttons(c)
  return {
    awful.button({}, 1, function()
      if c == client.focus then
        c.minimized = true
      else
        c:emit_signal("request::activate", "tasklist", {
          raise = true,
        })
      end
    end),
  }
end

local client_signals = {
  "tagged",
  "untagged",
  "list",
  "property::icon",
  "property::name",
  "property::minimized",
  "property::hidden",
  "property::skip_taskbar",
}

local function tasklist(s)
  local clients = signal({})

  local update_clients = throttle(function()
    clients:set(get_clients(s))
  end)

  for _, client_signal in ipairs(client_signals) do
    client.connect_signal(client_signal, update_clients)
  end
  awful.tag.attached_connect_signal(nil, "property::selected", update_clients)
  awful.tag.attached_connect_signal(nil, "property::activated", update_clients)

  local tasklist_widget = Row {
    spacing = dpi(4),
    max_widget_size = dpi(480),

    computed(function()
      return tbl.map(clients:get(), function(c)
        local active = bind(c, "active")
        local minimized = bind(c, "minimized")
        local urgent = bind(c, "urgent")

        return Flexible {
          Container {
            bg = computed(function()
              return active:get() and beautiful.bg_focus or urgent:get() and beautiful.bg_urgent or nil
            end),
            border_width = 1,
            border_color = computed(function()
              return active:get() and beautiful.border_focus or beautiful.colors.transparent
            end),
            padding = { x = dpi(8), y = dpi(4) },
            radius = dpi(4),
            buttons = tasklist_buttons(c),

            Row {
              spacing = dpi(6),
              ClientIcon { client = c },
              Text {
                color = computed(function()
                  return minimized:get() and beautiful.fg_minimized or nil
                end),
                bind(c, "name"),
              },
            },
          },
        }
      end)
    end),
  }

  return tasklist_widget
end

return tasklist

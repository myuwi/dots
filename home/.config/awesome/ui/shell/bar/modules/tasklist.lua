local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local hcolor = require("helpers.color")

local signal = require("tide.signal")
local computed = require("tide.signal.computed")
local watch = require("tide.signal.watch")

local For = require("tide.flow").For
local Container = require("tide.widget").Container
local Flexible = require("tide.widget").Flexible
local ClientIcon = require("tide.widget").ClientIcon
local Row = require("tide.widget").Row
local Text = require("tide.widget").Text

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
        -- c.minimized = true
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
    spacing = dpi(6),
    max_widget_size = dpi(480),

    For {
      each = clients,
      function(c)
        local active = watch(c, "active")
        -- TODO: local minimized = watch(c, "minimized")
        -- TODO: local urgent = watch(c, "urgent")
        local name = watch(c, "name")

        return Flexible {
          Container {
            padding = { x = dpi(6), y = dpi(6) },
            radius = dpi(4),
            buttons = tasklist_buttons(c),

            opacity = computed(function()
              return active:get() and 1 or 0.5
            end),

            Row {
              spacing = dpi(8),
              ClientIcon { client = c },
              Text {
                shadow = { x = 1, y = 1, blur = 8, color = hcolor.opacity("#000000", 0.6) },
                name,
              },
            },
          },
        }
      end,
    },
  }

  return tasklist_widget
end

return tasklist

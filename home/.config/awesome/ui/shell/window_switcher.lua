local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helpers = require("helpers")
local Window = require("ui.window")
local Container = require("ui.widgets").Container
local Column = require("ui.widgets").Column
local Row = require("ui.widgets").Row
local ClientIcon = require("ui.widgets").ClientIcon
local Text = require("ui.widgets").Text

local signal = require("ui.core.signal")
local computed = require("ui.core.signal.computed")
local map = require("ui.core.signal.map")

local backdrop = require("ui.shell.backdrop")

-- Somewhat replicates the Windows behavior
-- https://en.wikipedia.org/wiki/Alt-Tab#Behavior

local icon_size = dpi(60)
local icon_padding = dpi(12)
local outside_padding = dpi(12)
local icon_text_spacing = dpi(6)
local text_height = dpi(12)

local alt_tab_index = signal(1)
local visible_clients = signal({})
local window_switcher_keygrabber
local last_focused_client

---@param index integer
local function activate_client_at_index(index)
  local c = visible_clients.value[index]

  c:emit_signal("request::activate", "window_switcher", {
    raise = true,
  })
end

---@param c table
---@param i integer
local function create_icon(c, i)
  local hovered = signal(false)
  local client_icon = Container {
    bg = computed(function()
      if hovered.value then
        return beautiful.window_switcher_hover
      elseif i == alt_tab_index.value then
        return beautiful.window_switcher_focus
      else
        return beautiful.window_switcher_inactive
      end
    end),
    radius = beautiful.border_radius,
    padding = outside_padding,
    on_click = function()
      activate_client_at_index(i)
      window_switcher_keygrabber:stop()
    end,
    on_mouse_enter = function()
      hovered.value = true
    end,
    on_mouse_leave = function()
      hovered.value = false
    end,

    Column {
      forced_width = icon_size + icon_padding * 2,
      spacing = icon_text_spacing,

      Container {
        padding = icon_padding,

        -- TODO: Image { src = c, ... }
        ClientIcon {
          client = c,
          forced_height = icon_size,
          forced_width = icon_size,
        },
      },
      Text {
        text = c.name,
        halign = "center",
        valign = "center",
        forced_height = text_height,
      },
    },
  }

  return client_icon
end

local function create_client_icons(clients)
  local icons = {}

  for i, c in ipairs(clients) do
    icons[i] = create_icon(c, i)
  end

  return icons
end

local window_switcher_widget = Window.Popup {
  placement = awful.placement.centered,

  Row {
    spacing = dpi(6),
    children = map(visible_clients, create_client_icons),
  },
}

local function cancel()
  if window_switcher_keygrabber ~= nil then
    client.focus = last_focused_client
    window_switcher_keygrabber:stop()
  end
end

local function hide()
  visible_clients.value = {}
  last_focused_client = nil
  window_switcher_keygrabber = nil
  window_switcher_widget.visible = false
  backdrop.detach()
end

local function cycle_selection(amount)
  if amount == 0 then
    return
  end

  local new_index = alt_tab_index.value + amount
  alt_tab_index.value = (new_index - 1) % #visible_clients.value + 1
end

local function filter_function(c)
  return c.first_tag.selected
end

local function show(a)
  local cycle_amount = a or 1
  local clients = client.get(nil, true)
  visible_clients.value = helpers.table.filter(clients, filter_function)

  if #visible_clients.value == 0 then
    return
  elseif #visible_clients.value == 1 then
    visible_clients.value[1]:emit_signal("request::activate", "window_switcher", {
      raise = true,
    })
    return
  end

  window_switcher_keygrabber = awful.keygrabber({
    keybindings = {
      awful.key({ modkey }, "Tab", function()
        cycle_selection(1)
      end),
      awful.key({ modkey, "Shift" }, "Tab", function()
        cycle_selection(-1)
      end),
      awful.key({ modkey }, "Escape", cancel),
    },
    stop_key = modkey,
    stop_event = "release",
    stop_callback = function(_, stop_key)
      if stop_key == "Super_L" then
        activate_client_at_index(alt_tab_index.value)
      end

      hide()
    end,
  })

  alt_tab_index.value = 1

  if client.focus == nil and cycle_amount > 0 then
    cycle_amount = cycle_amount - 1
  end

  if cycle_amount ~= 0 then
    cycle_selection(cycle_amount)
  end

  last_focused_client = client.focus
  client.focus = nil

  backdrop.attach(cancel)

  window_switcher_keygrabber:start()
  window_switcher_widget.visible = true
end

awesome.connect_signal("shell::window_switcher::show", show)

local awful = require("awful")
local beautiful = require("beautiful")
-- local history = require("module.history")
local wibox = require("wibox")

local helpers = require("helpers")
local foreach = helpers.table.foreach
local filter = helpers.table.filter
local map = helpers.table.map

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local alt_tab_index = 1
local hover_index
local window_switcher_keygrabber
local visible_clients
local last_focused_client

local window_switcher_box
local app_icons

local function activate(index)
  c = visible_clients[index]

  c:emit_signal("request::activate", "window_switcher", {
    raise = true,
  })
end

local function redraw_highlights()
  foreach(app_icons, function(c, i)
    if hover_index == i then
      c.bg = beautiful.colors.overlay
    elseif alt_tab_index == i then
      c.bg = beautiful.colors.surface
    else
      c.bg = "#00000000"
    end
  end)
end

local function draw_widget()
  local icon_size = dpi(64)
  local icon_padding = dpi(8)

  local icon_top_margin = dpi(16)
  local icon_bottom_margin = dpi(8)
  local icon_x_margin = dpi(16)

  local icon_text_spacing = dpi(8)
  local text_height = dpi(16)

  local icon_spacing = dpi(8)
  local container_padding = dpi(16)

  app_icons = map(visible_clients, function(c, i)
    local widget = wibox.widget({
      {
        {
          {
            {
              awful.widget.clienticon(c),
              forced_height = icon_size,
              forced_width = icon_size,
              widget = wibox.container.margin,
            },
            margins = icon_padding,
            widget = wibox.container.margin,
          },
          {
            text = c.name,
            align = "center",
            valign = "center",
            ellipsize = "end",
            forced_width = icon_size + icon_padding * 2,
            forced_height = text_height,
            widget = wibox.widget.textbox,
          },
          spacing = icon_text_spacing,
          layout = wibox.layout.fixed.vertical,
          widget = wibox.container.margin,
        },
        top = icon_top_margin,
        left = icon_x_margin,
        right = icon_x_margin,
        bottom = icon_bottom_margin,
        widget = wibox.container.margin,
      },
      shape = helpers.shape.rounded_rect(beautiful.border_radius),
      bg = alt_tab_index == i and beautiful.colors.surface or "#00000000",
      widget = wibox.container.background,
    })

    helpers.ui.add_hover_cursor(widget, "hand2")

    widget:connect_signal("mouse::enter", function()
      hover_index = i
      redraw_highlights()
    end)

    widget:connect_signal("mouse::leave", function()
      hover_index = nil
      redraw_highlights()
    end)

    widget:connect_signal("button::press", function(_, _, _, button)
      if button == 1 then
        activate(i)
        window_switcher_keygrabber:stop()
      end
    end)

    return widget
  end)

  window_switcher_box = awful.popup({
    visible = false,
    ontop = true,
    screen = awful.screen.focused(),
    bg = "#00000000",
    shape = helpers.shape.rounded_rect(beautiful.border_radius * 2),
    widget = {
      {
        {
          children = app_icons,
          spacing = icon_spacing,
          layout = wibox.layout.fixed.horizontal,
        },
        margins = container_padding,
        widget = wibox.container.margin,
      },
      bg = beautiful.bg_normal,
      widget = wibox.container.background,
    },
  })

  local n_clients = #visible_clients

  local icon_width = icon_size + icon_padding * 2 + icon_x_margin * 2
  local widget_width = icon_width * n_clients + (n_clients - 1) * icon_spacing + 2 * container_padding
  local x_offset = -widget_width / 2

  local icon_height = icon_size
    + icon_top_margin
    + icon_padding * 2
    + icon_text_spacing
    + text_height
    + icon_bottom_margin
  local widget_height = icon_height + container_padding * 2
  local y_offset = -widget_height / 2

  -- Using the placement property directly in window_switcher_box causes
  -- weird artifacts for some reason
  awful.placement.centered(window_switcher_box, {
    offset = {
      x = x_offset,
      y = y_offset,
    },
  })
end

local function cycle(amount)
  if amount == 0 then
    return
  end

  local new_index = alt_tab_index + amount

  if new_index > #visible_clients then
    alt_tab_index = new_index - #visible_clients
  elseif new_index < 1 then
    alt_tab_index = #visible_clients - new_index
  else
    alt_tab_index = new_index
  end
end

local function hide()
  visible_clients = nil
  last_focused_client = nil
  window_switcher_keygrabber = nil
  window_switcher_box.visible = false
  window_switcher_box = nil
end

local function filter_function(c)
  return c.first_tag.selected
end

local function show(a)
  local cycle_amount = a or 1
  local h = client.get(nil, true)
  visible_clients = filter(h, filter_function)

  if #visible_clients == 0 then
    return
  elseif #visible_clients == 1 then
    visible_clients[1]:emit_signal("request::activate", "window_switcher", {
      raise = true,
    })
    return
  end

  window_switcher_keygrabber = awful.keygrabber({
    keybindings = {
      awful.key({
        modifiers = { modkey },
        key = "Tab",
        on_press = function()
          cycle(1)
          redraw_highlights()
        end,
      }),
      awful.key({
        modifiers = { modkey, "Shift" },
        key = "Tab",
        on_press = function()
          cycle(-1)
          redraw_highlights()
        end,
      }),
      awful.key({
        modifiers = { modkey },
        key = "Escape",
        on_press = function()
          client.focus = last_focused_client
          window_switcher_keygrabber:stop()
        end,
      }),
    },
    stop_key = modkey,
    stop_event = "release",
    stop_callback = function(_, stop_key)
      if stop_key == "Super_L" then
        activate(alt_tab_index)
      end

      hide()
    end,
  })

  alt_tab_index = 1

  if client.focus == nil and cycle_amount > 0 then
    cycle_amount = cycle_amount - 1
  end

  if cycle_amount ~= 0 then
    cycle(cycle_amount)
  end

  last_focused_client = client.focus
  client.focus = nil

  draw_widget()

  window_switcher_keygrabber:start()
  window_switcher_box.screen = mouse.screen
  window_switcher_box.visible = true
end

awesome.connect_signal("window_switcher::open", show)

return {
  show = show,
}

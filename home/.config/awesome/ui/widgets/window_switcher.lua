local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local helpers = require("helpers")

local backdrop = require("ui.widgets.backdrop")

-- Somewhat replicates the Windows behavior
-- https://en.wikipedia.org/wiki/Alt-Tab#Behavior

local alt_tab_index = 1
local hover_index
local window_switcher_keygrabber
local visible_clients
local last_focused_client

local client_icons = wibox.widget({
  spacing = dpi(6),
  layout = wibox.layout.fixed.horizontal,
})

local window_switcher_box = helpers.ui.popup({
  placement = awful.placement.centered,
  widget = client_icons,
})

local function activate_client_at_index(index)
  local c = visible_clients[index]

  c:emit_signal("request::activate", "window_switcher", {
    raise = true,
  })
end

local function redraw_highlights()
  for i, c in ipairs(client_icons.children) do
    if hover_index == i then
      c.bg = beautiful.window_switcher_hover
    elseif alt_tab_index == i then
      c.bg = beautiful.window_switcher_focus
    else
      c.bg = beautiful.window_switcher_inactive
    end
  end
end

local function draw_client_icons()
  local icon_size = dpi(60)
  local icon_padding = dpi(12)
  local outside_padding = dpi(12)
  local icon_text_spacing = dpi(6)
  local text_height = dpi(12)

  client_icons:reset()

  for i, c in ipairs(visible_clients) do
    local client_icon = wibox.widget({
      {
        {
          {
            {
              client = c,
              forced_height = icon_size,
              forced_width = icon_size,
              widget = awful.widget.clienticon,
            },
            margins = icon_padding,
            widget = wibox.container.margin,
          },
          {
            text = c.name,
            halign = "center",
            valign = "center",
            forced_height = text_height,
            widget = wibox.widget.textbox,
          },
          spacing = icon_text_spacing,
          forced_width = icon_size + icon_padding * 2,
          layout = wibox.layout.fixed.vertical,
        },
        margins = outside_padding,
        widget = wibox.container.margin,
      },
      shape = helpers.shape.rounded_rect(beautiful.border_radius),
      bg = alt_tab_index == i and beautiful.window_switcher_focus or beautiful.window_switcher_inactive,
      widget = wibox.container.background,
    })

    helpers.ui.add_hover_cursor(client_icon, "hand2")

    client_icon:connect_signal("mouse::enter", function()
      hover_index = i
      redraw_highlights()
    end)

    client_icon:connect_signal("mouse::leave", function()
      hover_index = nil
      redraw_highlights()
    end)

    client_icon.buttons = {
      awful.button({ "Any" }, 1, function()
        activate_client_at_index(i)
        window_switcher_keygrabber:stop()
      end),
    }

    client_icons:add(client_icon)
  end

  -- Hacky way to avoid popup not updating its position for one frame after it is made visible
  -- Possible due to this https://github.com/awesomeWM/awesome/blob/8b1f8958b46b3e75618bc822d512bb4d449a89aa/lib/awful/popup.lua#L115
  -- TODO: Is this okay to use?
  window_switcher_box:_apply_size_now()
end

local function cycle_selection(amount)
  if amount == 0 then
    return
  end

  local new_index = alt_tab_index + amount
  alt_tab_index = (new_index - 1) % #visible_clients + 1
end

local function cancel()
  if window_switcher_keygrabber ~= nil then
    client.focus = last_focused_client
    window_switcher_keygrabber:stop()
  end
end

local function hide()
  visible_clients = nil
  last_focused_client = nil
  window_switcher_keygrabber = nil
  window_switcher_box.visible = false
  backdrop.detach()
end

local function filter_function(c)
  return c.first_tag.selected
end

local function show(a)
  local cycle_amount = a or 1
  local clients = client.get(nil, true)
  visible_clients = helpers.table.filter(clients, filter_function)

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
      awful.key({ modkey }, "Tab", function()
        cycle_selection(1)
        redraw_highlights()
      end),
      awful.key({ modkey, "Shift" }, "Tab", function()
        cycle_selection(-1)
        redraw_highlights()
      end),
      awful.key({ modkey }, "Escape", cancel),
    },
    stop_key = modkey,
    stop_event = "release",
    stop_callback = function(_, stop_key)
      if stop_key == "Super_L" then
        activate_client_at_index(alt_tab_index)
      end

      hide()
    end,
  })

  alt_tab_index = 1

  if client.focus == nil and cycle_amount > 0 then
    cycle_amount = cycle_amount - 1
  end

  if cycle_amount ~= 0 then
    cycle_selection(cycle_amount)
  end

  last_focused_client = client.focus
  client.focus = nil

  draw_client_icons()

  backdrop.attach(cancel)

  window_switcher_keygrabber:start()
  window_switcher_box.screen = screen.primary
  window_switcher_box.visible = true
end

awesome.connect_signal("widgets::window_switcher::show", show)

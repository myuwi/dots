local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
local rubato = require("lib.rubato")
local wibox = require("wibox")

local client_order = {
  "firefox",
  "ArmCord",
  "discord",
  "Alacritty",
}

local icon_size = 48
local icon_spacing = 8
local dock_margin = beautiful.useless_gap * 2
local hover_area_height = beautiful.useless_gap

-- TODO: indicators
-- TODO: actually do anything useful
local function create_dock(s)
  local dock = awful.popup({
    ontop = true,
    bg = beautiful.bg_normal,
    visible = true,
    screen = s,
    type = "dock",
    shape = helpers.shape.rounded_rect(8),
    widget = wibox.container.background,
  })

  local function create_icons()
    local h = client.get(nil, false)
    local visible_clients = helpers.table.filter(h, function(c)
      return c.first_tag and c.first_tag.selected
    end)

    -- group clients based on their class
    local grouped_clients = {}
    for i = #visible_clients, 1, -1 do
      local c = visible_clients[i]
      if c.class then
        if not grouped_clients[c.class] then
          grouped_clients[c.class] = {}
        end
        grouped_clients[c.class][#grouped_clients[c.class] + 1] = c
      end
    end

    local ordered_grouped_clients = {}
    -- add ordered clients first
    for _, class in ipairs(client_order) do
      if grouped_clients[class] then
        ordered_grouped_clients[#ordered_grouped_clients + 1] = grouped_clients[class]
      end
    end
    -- add remaining clients
    for cls, clients in pairs(grouped_clients) do
      if not helpers.table.includes(client_order, cls) then
        ordered_grouped_clients[#ordered_grouped_clients + 1] = clients
      end
    end

    local widgets = wibox.widget({
      spacing = icon_spacing,
      layout = wibox.layout.fixed.horizontal,
    })

    for _, clients in ipairs(ordered_grouped_clients) do
      local c = clients[1]
      local widget = wibox.widget({
        {
          awful.widget.clienticon(c),
          forced_height = icon_size,
          forced_width = icon_size,
          widget = wibox.container.margin,
        },
        margins = 4,
        widget = wibox.container.margin,
      })

      helpers.ui.add_hover_cursor(widget, "hand2")
      widgets:add(widget)
    end
    return widgets
  end

  local function check_dock_visibility()
    if dock.screen.selected_tag == nil then
      return true
    end

    local clients = dock.screen.selected_tag:clients()
    for _, c in ipairs(clients) do
      if c.fullscreen then
        return false
      end

      local client_bottom_y = c.y + c.height
      local dock_area_height = dock.height + dock_margin * 2
      local overlaps_y = client_bottom_y > s.geometry.height - dock_area_height

      local client_left = c.x
      local client_right = c.x + c.width

      local dock_left = dock.x - dock_margin
      local dock_right = dock.x + dock.width + dock_margin

      local overlaps_x = client_left < dock_right and client_right > dock_left

      if overlaps_y and overlaps_x then
        return false
      end
    end
    return true
  end

  local hidden_y = s.geometry.height + 8

  local function center_dock()
    dock.x = s.geometry.x + s.geometry.width / 2 - dock.width / 2
  end

  local dock_transition = rubato.timed({
    duration = 0.2,
    pos = hidden_y,
    clamp_position = true,
    subscribed = function(pos)
      dock.y = pos
    end,
  })

  local function redraw_icons()
    dock:setup({
      {
        create_icons(),
        layout = wibox.layout.fixed.horizontal,
      },
      margins = 8,
      widget = wibox.container.margin,
    })
  end

  local function show_dock()
    local visible_y = s.geometry.height - (dock.height + dock_margin)
    dock_transition.target = visible_y
  end

  local function hide_dock()
    dock_transition.target = hidden_y
  end

  local function update_visibility()
    if check_dock_visibility() then
      show_dock()
    else
      hide_dock()
    end
  end

  local hide_dock_timer = gears.timer({
    timeout = 0.2,
    autostart = false,
    single_shot = true,
    callback = update_visibility,
  })

  local hover_area = wibox({
    screen = s,
    widget = wibox.container.background,
    ontop = false,
    opacity = 0,
    visible = true,
    width = 960,
    height = hover_area_height,
    type = "tooltip",
  })

  awful.placement.bottom(hover_area)

  local function show_dock_hovered()
    show_dock()
    hide_dock_timer:stop()
  end

  local function hide_dock_hovered()
    hide_dock_timer:again()
  end

  dock:connect_signal("mouse::enter", show_dock_hovered)
  hover_area:connect_signal("mouse::enter", show_dock_hovered)
  dock:connect_signal("mouse::leave", hide_dock_hovered)
  hover_area:connect_signal("mouse::leave", hide_dock_hovered)

  local function refresh()
    redraw_icons()
    update_visibility()
  end

  client.connect_signal("manage", refresh)
  client.connect_signal("unmanage", refresh)
  tag.connect_signal("property::selected", refresh)

  client.connect_signal("property::geometry", update_visibility)

  dock:connect_signal("property::width", center_dock)

  refresh()
end

create_dock(screen.primary)

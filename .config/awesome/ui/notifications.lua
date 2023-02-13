local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local menubar_utils = require("menubar.utils")
local naughty = require("naughty")
local wibox = require("wibox")
local helpers = require("helpers")
local button = require("ui.components.button")

naughty.config.defaults.app_name = "Notification"
naughty.config.defaults.ontop = true
naughty.config.defaults.screen = screen.primary
naughty.config.defaults.timeout = 6
naughty.config.defaults.title = "Notification"
naughty.config.defaults.position = "bottom_right"

-- TODO: Mark the client that owns the notification as urgent when a notification arrives?
naughty.connect_signal("request::display", function(n)
  local notification_body_width = beautiful.notification_width - beautiful.notification_margin * 2
  -- Adjust for icon width and spacing
  if n.icon ~= nil then
    notification_body_width = notification_body_width - dpi(64) - dpi(16)
  end

  local notification_body = wibox.widget.textbox(n.message, true)
  notification_body.ellipsize = "none"
  notification_body.valign = "top"
  notification_body.forced_height = notification_body:get_height_for_width(notification_body_width, screen.primary)

  local action_button_hovered = false

  -- TODO: Make this cleaner?
  local action_button = function()
    local btn = button()

    btn:connect_signal("mouse::enter", function()
      action_button_hovered = true
    end)

    btn:connect_signal("mouse::leave", function()
      action_button_hovered = false
    end)

    return btn
  end

  local actions = {
    base_layout = wibox.widget({
      spacing = dpi(8),
      layout = wibox.layout.flex.horizontal,
    }),
    widget_template = action_button,
    style = {
      underline_normal = false,
      underline_selected = true,
    },
    widget = naughty.list.actions,
  }

  local app_icon = menubar_utils.lookup_icon(string.lower(n.app_name))

  local notification = naughty.layout.box({
    notification = n,
    type = "notification",
    bg = beautiful.colors.transparent,
    border_width = dpi(0),
    widget_template = {
      {
        {
          {
            {
              {
                {
                  {
                    forced_width = 16,
                    forced_height = 16,
                    image = app_icon,
                    widget = wibox.widget.imagebox,
                  },
                  visible = app_icon ~= nil,
                  right = dpi(6),
                  widget = wibox.container.margin,
                },
                {
                  {
                    text = n.app_name,
                    -- forced_height = dpi(16),
                    ellipsize = "end",
                    widget = wibox.widget.textbox,
                  },
                  halign = "left",
                  widget = wibox.container.place,
                },
                {
                  forced_width = 16,
                  forced_height = 16,
                  image = beautiful.icon_path .. "x.svg",
                  widget = wibox.widget.imagebox,
                },
                layout = wibox.layout.align.horizontal,
              },
              bottom = dpi(16),
              widget = wibox.container.margin,
            },
            {
              {
                visible = n.icon ~= nil,
                clip_shape = helpers.shape.rounded_rect(dpi(4)),
                forced_width = dpi(64),
                forced_height = dpi(64),
                image = n.icon,
                widget = wibox.widget.imagebox,
              },
              {
                {
                  {
                    text = n.title,
                    font = beautiful.font_name .. " Bold " .. beautiful.font_size,
                    forced_height = dpi(16),
                    ellipsize = "end",
                    widget = wibox.widget.textbox,
                  },
                  notification_body,
                  spacing = dpi(2),
                  layout = wibox.layout.fixed.vertical,
                },
                top = dpi(6),
                bottom = dpi(8),
                widget = wibox.container.margin,
              },
              spacing = dpi(16),
              layout = wibox.layout.fixed.horizontal,
            },
            {
              actions,
              visible = n.actions and #n.actions > 0,
              top = dpi(16),
              widget = wibox.container.margin,
            },
            layout = wibox.layout.fixed.vertical,
          },
          margins = beautiful.notification_margin,
          widget = wibox.container.margin,
        },
        bg = beautiful.bg_normal,
        border_color = beautiful.border_color,
        border_width = beautiful.widget_border_width,
        shape = helpers.shape.rounded_rect(beautiful.border_radius),
        widget = wibox.container.background,
      },
      forced_width = beautiful.notification_width,
      widget = wibox.layout.fixed.vertical,
    },
  })

  -- Stop notification from disappearing if it is hovered
  local notif_mouse_enter = function()
    n:reset_timeout(86400) -- a long time
  end

  local notif_mouse_leave = function()
    n:reset_timeout(naughty.config.defaults.timeout)
  end

  -- Remove default click events
  -- notification:set_buttons({})

  notification:connect_signal("mouse::enter", notif_mouse_enter)
  notification:connect_signal("mouse::leave", notif_mouse_leave)

  n:connect_signal("destroyed", function(n, reason)
    notification:disconnect_signal("mouse::enter", notif_mouse_enter)
    notification:disconnect_signal("mouse::leave", notif_mouse_leave)

    local mouse_left_down = mouse.is_left_mouse_button_pressed

    if
      reason == naughty.notification_closed_reason.dismissed_by_user
      and mouse_left_down
      and not action_button_hovered
    then
      -- TODO: Improve?
      -- Jump to client when a notification is left clicked
      if #n.clients > 0 then
        local c = n.clients[1]
        c:jump_to()
        local geometry = c:geometry()
        local x = geometry.x + geometry.width / 2
        local y = geometry.y + geometry.height / 2
        mouse.coords({ x = x, y = y })
      end
    end
  end)
end)

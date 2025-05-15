local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")
local wibox = require("wibox")

local helpers = require("helpers")
local widget = require("ui.widgets")

naughty.config.defaults.app_name = "Notification"
naughty.config.defaults.ontop = true
naughty.config.defaults.screen = screen.primary
naughty.config.defaults.timeout = 6
naughty.config.defaults.title = "Notification"
naughty.config.defaults.position = "bottom_right"

---@param args table
local function add_notification_icon(args)
  if not args.icon and args.app_name then
    local app_icon = helpers.client.find_icon(args.app_name)
    if app_icon then
      args.app_icon = app_icon
    end
  end
  return args
end

naughty.config.notify_callback = function(args)
  return add_notification_icon(args)
end

naughty.connect_signal("request::display", function(n)
  local notification_body_width = beautiful.notification_width - beautiful.notification_margin * 2
  -- Adjust for icon width and spacing
  if n.image ~= nil then
    notification_body_width = notification_body_width - dpi(60) - dpi(12)
  end

  local notification_body = wibox.widget({
    text = n.message,
    ellipsize = "none",
    valign = "top",
    widget = wibox.widget.textbox,
  })

  notification_body.forced_height = notification_body:get_height_for_width(notification_body_width, screen.primary)

  -- FIXME: Race condition (?) in "invoked" signal handler sometimes causes "dismissed_by_user"
  --        to be returned as the reason for dismissal even when action button is pressed
  local actions = {
    children = helpers.table.map(n.actions, function(action)
      local btn = widget.button({
        text = action:get_name(),
        buttons = {
          awful.button({}, 1, function()
            action:invoke(n)
          end),
        },
      })

      return btn
    end),
    spacing = dpi(6),
    layout = wibox.layout.flex.horizontal,
  }

  local notification_widget = naughty.layout.box({
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
                  image = n.app_icon,
                  forced_width = dpi(18),
                  forced_height = dpi(18),
                  visible = n.app_icon ~= nil,
                  widget = wibox.widget.imagebox,
                },
                {
                  text = n.app_name,
                  widget = wibox.widget.textbox,
                },
                spacing = dpi(6),
                layout = wibox.layout.fixed.horizontal,
              },
              bottom = dpi(12),
              widget = wibox.container.margin,
            },
            {
              {
                image = n.image,
                forced_width = dpi(60),
                forced_height = dpi(60),
                clip_shape = helpers.shape.rounded_rect(dpi(3)),
                visible = n.image ~= nil,
                widget = wibox.widget.imagebox,
              },
              {
                {
                  {
                    text = n.title,
                    font = beautiful.font_name .. " Bold " .. beautiful.font_size,
                    forced_height = dpi(18),
                    widget = wibox.widget.textbox,
                  },
                  notification_body,
                  spacing = dpi(3),
                  layout = wibox.layout.fixed.vertical,
                },
                top = dpi(6),
                bottom = dpi(6),
                widget = wibox.container.margin,
              },
              spacing = dpi(12),
              layout = wibox.layout.fixed.horizontal,
            },
            {
              actions,
              visible = n.actions and #n.actions > 0,
              top = dpi(12),
              widget = wibox.container.margin,
            },
            layout = wibox.layout.fixed.vertical,
          },
          margins = beautiful.notification_margin,
          widget = wibox.container.margin,
        },
        bg = beautiful.bg_normal,
        border_color = beautiful.border_color,
        border_width = beautiful.border_width,
        shape = helpers.shape.rounded_rect(beautiful.border_radius),
        widget = wibox.container.background,
      },
      forced_width = beautiful.notification_width,
      layout = wibox.layout.fixed.vertical,
    },
  })

  local timeout = n.timeout

  -- Stop notification from disappearing when it is hovered
  local notif_mouse_enter = function()
    n:reset_timeout(86400) -- a long time
  end

  local notif_mouse_leave = function()
    n:reset_timeout(timeout)
  end

  notification_widget.buttons = {
    awful.button({}, 1, function()
      n:destroy(naughty.notification_closed_reason.dismissed_by_user)
    end),
    awful.button({}, 3, function()
      n:destroy(naughty.notification_closed_reason.expired)
    end),
  }

  notification_widget:connect_signal("mouse::enter", notif_mouse_enter)
  notification_widget:connect_signal("mouse::leave", notif_mouse_leave)

  n:connect_signal("destroyed", function(destroyed_notif, reason)
    notification_widget:disconnect_signal("mouse::enter", notif_mouse_enter)
    notification_widget:disconnect_signal("mouse::leave", notif_mouse_leave)

    if reason == naughty.notification_closed_reason.dismissed_by_user then
      local client = destroyed_notif.clients[1]
      if client then
        client.first_tag:view_only()
        client:activate()
      end
    end
  end)
end)

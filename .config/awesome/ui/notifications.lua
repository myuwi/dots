local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
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
    notification_body_width = notification_body_width - dpi(64) - dpi(16)
  end

  local notification_body = wibox.widget.textbox(n.message, true)
  notification_body.ellipsize = "none"
  notification_body.valign = "top"
  notification_body.forced_height = notification_body:get_height_for_width(notification_body_width, screen.primary)

  local actions = {
    children = helpers.table.map(n.actions, function(action)
      local btn = button({ text = action:get_name() })

      btn.buttons = {
        awful.button({}, 1, function()
          action:invoke(n)
        end),
      }

      return btn
    end),
    spacing = dpi(8),
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
                  {
                    forced_width = dpi(16),
                    forced_height = dpi(16),
                    image = n.app_icon,
                    widget = wibox.widget.imagebox,
                  },
                  visible = n.app_icon ~= nil,
                  right = dpi(6),
                  widget = wibox.container.margin,
                },
                {
                  {
                    text = n.app_name,
                    ellipsize = "end",
                    widget = wibox.widget.textbox,
                  },
                  halign = "left",
                  widget = wibox.container.place,
                },
                {
                  forced_width = dpi(16),
                  forced_height = dpi(16),
                  image = beautiful.icon_path .. "close.svg",
                  widget = wibox.widget.imagebox,
                },
                layout = wibox.layout.align.horizontal,
              },
              bottom = dpi(16),
              widget = wibox.container.margin,
            },
            {
              {
                visible = n.image ~= nil,
                clip_shape = helpers.shape.rounded_rect(dpi(4)),
                forced_width = dpi(64),
                forced_height = dpi(64),
                image = n.image,
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
      if #destroyed_notif.clients > 0 then
        local c = destroyed_notif.clients[1]
        c:jump_to()
      end
    end
  end)
end)

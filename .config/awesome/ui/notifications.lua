local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")
local wibox = require("wibox")
local helpers = require("helpers")

local button = require("ui.components.button")

naughty.config.defaults.ontop = true
naughty.config.defaults.screen = screen.primary
naughty.config.defaults.timeout = 6
naughty.config.defaults.title = "Notification"
naughty.config.defaults.position = "bottom_right"

-- naughty.connect_signal("destroyed", function(n, reason)
--   -- Notification dismissed manually with the left mouse button
--   -- TODO: Raise the client corresponding to the notification if it exists
--   if reason == naughty.notification_closed_reason.dismissed_by_user and mouse.is_left_mouse_button_pressed then
--   end
-- end)

naughty.connect_signal("request::display", function(n)
  local notification_body = wibox.widget.textbox(n.message, true)
  notification_body.ellipsize = "none"
  notification_body.valign = "top"
  notification_body.forced_height = notification_body:get_height_for_width(
    dpi(360 - beautiful.notification_margin * 2),
    awful.screen.focused()
  )

  local actions = {
    base_layout = wibox.widget({
      spacing = dpi(8),
      layout = wibox.layout.flex.horizontal,
    }),
    widget_template = button,
    style = {
      underline_normal = false,
      underline_selected = true,
    },
    widget = naughty.list.actions,
  }

  naughty.layout.box({
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
                visible = n.icon ~= nil,
                clip_shape = helpers.shape.rounded_rect(dpi(4)),
                forced_width = dpi(64),
                forced_height = dpi(64),
                image = n.icon,
                widget = wibox.widget.imagebox,
              },
              {
                {
                  text = n.title,
                  font = beautiful.font_bold,
                  forced_height = dpi(16),
                  ellipsize = "end",
                  widget = wibox.widget.textbox,
                },
                notification_body,
                spacing = dpi(8),
                layout = wibox.layout.fixed.vertical,
              },
              fill_space = true,
              spacing = dpi(8),
              layout = wibox.layout.fixed.horizontal,
            },
            {
              {
                actions,
                layout = wibox.layout.fixed.vertical,
              },
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
        shape_border_width = beautiful.widget_border_width,
        shape_border_color = beautiful.border_color,
        shape = helpers.shape.rounded_rect(beautiful.border_radius),
        widget = wibox.container.background,
      },
      forced_width = dpi(360),
      widget = wibox.layout.fixed.vertical,
    },
  })
end)

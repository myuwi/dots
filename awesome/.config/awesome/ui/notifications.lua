local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")
local wibox = require("wibox")
local helpers = require("helpers")

naughty.config.defaults.ontop = true
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = "Notification"
naughty.config.defaults.position = "bottom_right"

naughty.connect_signal("request::display", function(n)
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
              naughty.widget.icon,
              {
                {
                  text = n.title,
                  font = beautiful.font_name .. " Bold 9",
                  forced_height = dpi(16),
                  widget = wibox.widget.textbox,
                },
                naughty.widget.message,
                spacing = dpi(4),
                layout = wibox.layout.fixed.vertical,
              },
              fill_space = true,
              spacing = dpi(8),
              layout = wibox.layout.fixed.horizontal,
            },
            {
              {
                naughty.list.actions,
                layout = wibox.layout.fixed.vertical,
              },
              margins = dpi(8),
              visible = n.actions and #n.actions > 0,
              widget = wibox.container.margin,
            },
            layout = wibox.layout.fixed.vertical,
          },
          margins = beautiful.notification_margin,
          widget = wibox.container.margin,
        },
        bg = beautiful.colors.surface,
        shape = helpers.rounded_rect(beautiful.border_radius),
        widget = wibox.container.background,
      },
      forced_width = dpi(320),
      widget = wibox.layout.fixed.vertical,
    },
  })
end)

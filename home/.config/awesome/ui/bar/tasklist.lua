local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local helpers = require("helpers")

local fit = require("ui.layout.fit")

local tasklist = function(s)
  local tasklist_buttons = {
    awful.button({}, 1, function(c)
      if c == client.focus then
        c.minimized = true
      else
        c:emit_signal("request::activate", "tasklist", {
          raise = true,
        })
      end
    end),
  }

  local tasklist_widget = awful.widget.tasklist({
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
    layout = {
      layout = fit.horizontal,
      max_widget_size = dpi(480),
      spacing = dpi(4),
    },
    style = {
      shape = helpers.shape.rounded_rect(4),
    },
    widget_template = {
      {
        {
          {
            awful.widget.clienticon,
            left = dpi(4),
            widget = wibox.container.margin,
          },
          {
            {
              id = "text_role",
              widget = wibox.widget.textbox,
            },
            right = dpi(4),
            widget = wibox.container.margin,
          },
          spacing = dpi(6),
          layout = wibox.layout.fixed.horizontal,
        },
        margins = dpi(4),
        widget = wibox.container.margin,
      },
      id = "background_role",
      widget = wibox.container.background,
    },
  })

  return tasklist_widget
end

return tasklist

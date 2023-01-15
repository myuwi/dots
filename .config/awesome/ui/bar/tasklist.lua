local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local fit = require("ui.layout.fit")
local rounded_rect = require("helpers").shape.rounded_rect

local function update_task_background(w, c)
  if c.active then
    w.bg = beautiful.bg_tasklist_active
  elseif c.minimized then
    w.bg = beautiful.bg_tasklist_minimized
  else
    w.bg = beautiful.bg_tasklist_inactive
  end
end

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

  local widget_tasklist = awful.widget.tasklist({
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
    layout = {
      layout = fit.horizontal,
      max_widget_size = dpi(480),
      spacing = dpi(4),
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
      shape = rounded_rect(4),
      widget = wibox.container.background,
      create_callback = update_task_background,
      update_callback = update_task_background,
    },
  })

  return widget_tasklist
end

return tasklist

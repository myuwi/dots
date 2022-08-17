local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local fit = require("ui.layout.fit")

local rounded_rect = require("helpers").shape.rounded_rect

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
        forced_height = dpi(32),
        widget = wibox.container.background,
        shape = rounded_rect(4),
        id = "background",
      },
      top = dpi(4),
      bottom = dpi(4),
      widget = wibox.container.margin,
      create_callback = function(self, c, index, clients)
        self:get_children_by_id("background")[1].bg = beautiful.bg_tasklist_active
      end,
      update_callback = function(self, c, index, clients)
        local widget_background = self:get_children_by_id("background")[1]

        if c.active then
          widget_background.bg = beautiful.bg_tasklist_active
        elseif c.minimized then
          widget_background.bg = beautiful.bg_minimize
        else
          widget_background.bg = beautiful.bg_tasklist_inactive
        end
      end,
    },
  })

  return widget_tasklist
end

return tasklist

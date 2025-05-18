local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local hshape = require("helpers.shape")
local bind = require("ui.core.bind")

local calendar_popup = require("ui.shell.calendar_popup")

local clock = function()
  local clock_buttons = {
    awful.button({}, 1, function()
      awesome.emit_signal("shell::calendar_popup::show")
    end),
  }

  local clock_widget = wibox.widget({
    {
      {
        {
          format = "%a %d %b %H:%M",
          widget = wibox.widget.textclock,
        },
        widget = wibox.container.place,
      },
      left = dpi(6),
      right = dpi(6),
      widget = wibox.container.margin,
    },
    buttons = clock_buttons,
    shape = hshape.rounded_rect(4),
    widget = wibox.container.background,
  })

  bind(calendar_popup, "visible", function(visible)
    clock_widget.bg = visible and beautiful.bg_focus or nil
  end)

  return clock_widget
end

return clock

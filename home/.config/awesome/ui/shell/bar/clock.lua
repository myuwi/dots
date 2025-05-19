local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local hshape = require("helpers.shape")
local observe = require("ui.core.signal.observe")

local calendar_popup = require("ui.shell.calendar_popup")
local calendar_visible = observe(calendar_popup, "visible")

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

  calendar_visible:subscribe(function(visible)
    clock_widget.bg = visible and beautiful.bg_focus or nil
  end)

  return clock_widget
end

return clock

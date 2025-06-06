local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local hshape = require("helpers.shape")

local widget = require("ui.widgets")

local computed = require("ui.core.signal.computed")
local observe = require("ui.core.signal.observe")

local calendar_popup = require("ui.shell.calendar_popup")
local calendar_visible = observe(calendar_popup, "visible")

local function clock(s)
  local clock_widget = widget.new({
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
    bg = computed(function()
      return calendar_visible.value and calendar_popup.screen == s and beautiful.bg_focus or nil
    end),
    buttons = {
      awful.button({}, 1, function()
        awesome.emit_signal("shell::calendar_popup::show")
      end),
    },
    shape = hshape.rounded_rect(4),
    widget = wibox.container.background,
  })

  return clock_widget
end

return clock

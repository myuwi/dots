local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local Container = require("ui.widgets").Container
local TextClock = require("ui.widgets").TextClock

local computed = require("lib.signal.computed")
local bind = require("lib.signal.bind")

local calendar_popup = require("ui.shell.bar.popups.calendar_popup")
local calendar_visible = bind(calendar_popup, "visible")

local function clock(s)
  local clock_widget = Container {
    bg = computed(function()
      return calendar_visible:get() and calendar_popup.screen == s and beautiful.bg_focus or nil
    end),
    border_width = 1,
    border_color = computed(function()
      return calendar_visible:get() and calendar_popup.screen == s and beautiful.border_focus
        or beautiful.colors.transparent
    end),
    radius = dpi(4),
    padding = { x = dpi(8) },
    on_button_press = function(_, _, _, button)
      if button == 1 then
        calendar_popup.show()
      end
    end,

    TextClock { "%d %b %H:%M" },
  }

  return clock_widget
end

return clock

local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local Container = require("ui.widgets").Container
local TextClock = require("ui.widgets").TextClock

local computed = require("ui.core.signal.computed")
local bind = require("ui.core.signal.bind")

local calendar_popup = require("ui.shell.calendar_popup")
local calendar_visible = bind(calendar_popup, "visible")

local function clock(s)
  local clock_widget = Container {
    bg = computed(function()
      return calendar_visible.value and calendar_popup.screen == s and beautiful.bg_focus or nil
    end),
    radius = dpi(4),
    padding = { x = dpi(6) },
    on_button_press = function(_, _, _, button)
      if button == 1 then
        awesome.emit_signal("shell::calendar_popup::show")
      end
    end,

    TextClock { "%a %d %b %H:%M" },
  }

  return clock_widget
end

return clock

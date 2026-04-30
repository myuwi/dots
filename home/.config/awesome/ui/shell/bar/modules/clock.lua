local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local Container = require("tide.widget").Container
local TextClock = require("tide.widget").TextClock
local Calendar = require("ui.components").Calendar
local Popover = require("ui.components").Popover

local computed = require("tide.signal.computed")

local function clock(_)
  local calendar = Calendar {}

  return Popover {
    placement = "bottom",
    on_open_change = function(visible)
      if visible then
        calendar:reset()
      end
    end,

    trigger = function(state)
      return Container {
        bg = computed(function()
          return state.open:get() and beautiful.bg_bar_item_focus or nil
        end),
        radius = dpi(4),
        padding = { x = dpi(8) },
        on_button_press = function(_, _, _, button)
          if button == 1 then
            state.toggle()
          end
        end,

        TextClock { "%d %b %H:%M" },
      }
    end,

    content = calendar,
  }
end

return clock

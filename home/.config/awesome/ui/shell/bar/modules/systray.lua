local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local Container = require("tide.widget").Container
local Center = require("tide.widget").Center
local Systray = require("tide.widget").Systray
local Icon = require("ui.components").Icon
local Popover = require("ui.components").Popover

local computed = require("tide.signal.computed")

local function systray()
  return Popover {
    placement = "bottom",

    trigger = function(state)
      return Container {
        bg = computed(function()
          return state.open:get() and beautiful.bg_bar_item_focus or nil
        end),
        radius = dpi(4),
        forced_width = dpi(28),
        on_button_press = function(_, _, _, button)
          if button == 1 then
            state.toggle()
          end
        end,

        Center {
          Icon { size = dpi(14), "chevron-down" },
        },
      }
    end,

    content = Systray {
      screen = screen.primary,
      base_size = dpi(16),
    },
  }
end

return systray

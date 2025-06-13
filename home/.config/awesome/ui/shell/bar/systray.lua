local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local Container = require("ui.widgets").Container
local Center = require("ui.widgets").Center
local Systray = require("ui.widgets").Systray

local function systray()
  local systray_widget = Container {
    padding = { x = beautiful.bar_spacing },
    Center {
      Systray {
        screen = screen.primary,
        base_size = dpi(16),
      },
    },
  }

  return systray_widget
end

return systray

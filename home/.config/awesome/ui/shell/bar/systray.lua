local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local Systray = require("ui.widgets").Systray
local Center = require("ui.widgets").Center

local function systray()
  local systray_widget = Center {
    Systray {
      screen = screen.primary,
      base_size = dpi(16),
    },
  }

  return systray_widget
end

return systray

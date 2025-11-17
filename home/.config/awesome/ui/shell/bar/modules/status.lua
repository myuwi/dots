local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local Container = require("ui.widgets").Container
local Row = require("ui.widgets").Row
local Icon = require("ui.components").Icon

local computed = require("ui.core.signal.computed")
local bind = require("ui.core.signal.bind")

local quick_settings = require("ui.shell.bar.popups.quick_settings")
local quick_settings_open = bind(quick_settings, "visible")

local function StyledIcon(args)
  return Icon {
    size = dpi(14),
    args[1],
  }
end

local function status()
  local status_widget = Container {
    bg = computed(function()
      return quick_settings_open:get() and beautiful.bg_focus or nil
    end),
    border_width = 1,
    border_color = computed(function()
      return quick_settings_open:get() and beautiful.border_focus or beautiful.colors.transparent
    end),
    radius = dpi(4),
    padding = { x = dpi(8) },
    on_button_press = function(_, _, _, button)
      if button == 1 then
        quick_settings.show()
      end
    end,

    -- TODO: show appropriate icons
    Row {
      align_items = "center",
      spacing = dpi(10),
      StyledIcon { "ethernet-port" },
      StyledIcon { "volume-1" },
    },
  }

  return status_widget
end

return status

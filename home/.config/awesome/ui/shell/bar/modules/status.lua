local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local upower = require("lgi").UPowerGlib

local Container = require("ui.widgets").Container
local Row = require("ui.widgets").Row
local Stack = require("ui.widgets").Stack
local Text = require("ui.widgets").Text
local Icon = require("ui.components").Icon

local computed = require("lib.signal.computed")
local bind = require("lib.signal.bind")

local quick_settings = require("ui.shell.bar.popups.quick_settings")
local quick_settings_open = bind(quick_settings, "visible")

local battery_state = require("state.battery")

local function StyledIcon(args)
  return Container {
    padding = dpi(1),
    Icon {
      size = dpi(14),
      color = args.color,
      args[1],
    },
  }
end

local function Volume(_)
  return Stack {
    StyledIcon { "volume-2", color = beautiful.colors.muted },
    StyledIcon { "volume-1" },
  }
end

local function Battery(_)
  if not battery_state:get() then
    return
  end

  return Row {
    align_items = "center",
    spacing = dpi(6),

    Icon {
      size = dpi(16),
      computed(function()
        local percentage = battery_state:get().percentage
        local state = battery_state:get().state

        if
          state == upower.DeviceState.CHARGING
          or state == upower.DeviceState.FULLY_CHARGED
          or state == upower.DeviceState.PENDING_CHARGE
        then
          return "battery-charging"
        end

        if percentage > 80 then
          return "battery-full"
        elseif percentage > 40 then
          return "battery-medium"
        elseif percentage > 20 then
          return "battery-low"
        else
          return "battery-warning"
        end
      end),
    },
    Text {
      computed(function()
        return battery_state:get().percentage .. "%"
      end),
    },
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
      spacing = dpi(8),
      StyledIcon { "ethernet-port" },
      Volume {},
      Battery {},
    },
  }

  return status_widget
end

return status

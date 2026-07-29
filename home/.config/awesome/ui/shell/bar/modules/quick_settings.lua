local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local upower = require("lgi").UPowerGlib

local helpers = require("helpers")

local Container = require("tide.widget").Container
local Column = require("tide.widget").Column
local Grid = require("tide.widget").Grid
local Row = require("tide.widget").Row
local Text = require("tide.widget").Text
local Icon = require("ui.components").Icon
local Popover = require("ui.components").Popover

local signal = require("tide.signal")
local computed = require("tide.signal.computed")

local battery_state = require("state.battery")
local network_state = require("state.network")
local audio_state = require("state.audio")

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

local function Pill(args)
  local enabled = args.enabled

  local fg_color = computed(function()
    return enabled:get() and beautiful.colors.base or beautiful.fg_normal
  end)

  return Column {
    align_items = "center",
    spacing = dpi(6),

    Container {
      forced_height = dpi(44),
      forced_width = dpi(80),
      bg = computed(function()
        return enabled:get() and beautiful.colors.accent or beautiful.bg_focus
      end),
      border_width = 1,
      border_color = computed(function()
        return enabled:get() and beautiful.colors.accent or beautiful.border_focus
      end),
      radius = beautiful.corner_radius,

      on_click = args.on_click,

      Row {
        align_items = "center",
        justify_content = "center",
        spacing = dpi(6),

        Icon {
          color = fg_color,
          args.icon,
        },
        args.external and Icon { color = fg_color, "chevron-right" } or nil,
      },
    },

    Text { args.name },
  }
end

-- TODO: Poll for updates when quick settings is open
local compositor_active = signal(false)
local screensaver_enabled = signal(false)

local function update_compositor_status()
  awful.spawn.easy_async_with_shell("pgrep picom", function(stdout)
    local active = stdout:match("%d+") ~= nil
    compositor_active:set(active)
  end)
end

local function update_screensaver_status()
  awful.spawn.easy_async("xset q | grep -A2 'Screen Saver'", function(stdout)
    local active = not stdout:match("timeout:  0")
    screensaver_enabled:set(active)
  end)
end

local function on_network_click()
  awful.spawn("nm-connection-editor", false)
end

local function on_bluetooth_click()
  awful.spawn("blueman-manager", false)
end

local function on_compositor_click()
  helpers.run.toggle("picom", function(pid)
    compositor_active:set(pid ~= nil)
  end)
end

local function on_screensaver_click()
  awful.spawn.easy_async_with_shell(
    "xset q | grep 'timeout:  0' && (xset s on && xset +dpms) || (xset s off && xset -dpms)",
    update_screensaver_status
  )
end

local function QuickSettingsContent(_)
  local network_enabled = computed(function()
    return network_state.state:get().connected
  end)
  local network_name = computed(function()
    return network_state.state:get().label
  end)

  return Column {
    spacing = dpi(6),

    Grid {
      column_count = 3,
      spacing = dpi(12),
      homogenous = true,

      Pill {
        icon = computed(function()
          return network_state.state:get().icon
        end),
        name = network_name,
        on_click = on_network_click,
        enabled = network_enabled,
        external = true,
      },
      Pill {
        icon = "bluetooth",
        name = "Bluetooth",
        on_click = on_bluetooth_click,
        enabled = signal(false),
        external = true,
      },
      Pill {
        icon = "sparkles",
        name = "Compositor",
        on_click = on_compositor_click,
        enabled = compositor_active,
      },
      Pill {
        icon = "moon",
        name = "Screensaver",
        on_click = on_screensaver_click,
        enabled = screensaver_enabled,
      },
    },
  }
end

local function Volume(_)
  return StyledIcon {
    computed(function()
      return audio_state.state:get().icon
    end),
  }
end

local function Network(_)
  return StyledIcon {
    computed(function()
      return network_state.state:get().icon
    end),
    color = computed(function()
      return network_state.state:get().connected and beautiful.fg_normal or beautiful.colors.muted
    end),
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

local function quick_settings()
  return Popover {
    placement = "bottom",
    padding = dpi(18),
    on_open_change = function(visible)
      if visible then
        network_state.refresh()
        audio_state.refresh()
        update_screensaver_status()
        update_compositor_status()
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

        Row {
          align_items = "center",
          spacing = dpi(8),
          Network {},
          Volume {},
          Battery {},
        },
      }
    end,

    content = QuickSettingsContent {},
  }
end

return quick_settings

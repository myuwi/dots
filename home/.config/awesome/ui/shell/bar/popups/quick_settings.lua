local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helpers = require("helpers")

local Window = require("ui.window")
local Container = require("ui.widgets").Container
local Column = require("ui.widgets").Column
local Row = require("ui.widgets").Row
local Grid = require("ui.widgets").Grid
local Text = require("ui.widgets").Text
local Image = require("ui.widgets").Image

local signal = require("ui.core.signal")
local computed = require("ui.core.signal.computed")

-- TODO: One common Icon component
local function Icon(args)
  local image = computed(function()
    local name = signal.is_signal(args[1]) and args[1]:get() or args[1]
    return beautiful.icon_path .. name .. ".svg"
  end)

  local stylesheet = computed(function()
    local color = signal.is_signal(args.color) and args.color:get() or args.color
    return "* { color:" .. (color or beautiful.fg_normal) .. " }"
  end)

  return Image {
    image = image,
    stylesheet = stylesheet,
    scaling_quality = "best",
    forced_width = args.size or dpi(14),
    forced_height = args.size or dpi(14),
  }
end

local function Pill(args)
  local fg_color = computed(function()
    return args.enabled:get() and beautiful.colors.base or beautiful.fg_normal
  end)

  return Column {
    align_items = "center",
    spacing = dpi(6),

    Container {
      forced_height = dpi(44),
      forced_width = dpi(80),
      bg = computed(function()
        return args.enabled:get() and beautiful.colors.accent or beautiful.bg_focus
      end),
      border_width = 1,
      border_color = computed(function()
        return args.enabled:get() and beautiful.colors.accent or beautiful.border_focus
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

-- TODO: get real statuses for wifi and bluetooth
local quick_settings = Window.Popup {
  placement = function(w)
    awful.placement.top_right(w, {
      margins = beautiful.useless_gap * 2,
      honor_workarea = true,
    })
  end,
  padding = dpi(18),

  Column {
    spacing = dpi(6),

    -- TODO: Move handler to Window.Popup
    on_mount = function()
      update_screensaver_status()
      update_compositor_status()
    end,

    Grid {
      column_count = 3,
      spacing = dpi(12),
      homogenous = true,

      Pill {
        icon = "ethernet-port",
        name = "Wired",
        on_click = on_network_click,
        enabled = signal(true),
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
  },
}

helpers.window.set_prop(quick_settings, "_ANIMATE", "slide-down")

local click_away_handler = helpers.ui.create_click_away_handler(quick_settings, true)

function quick_settings.hide()
  quick_settings.visible = false
  click_away_handler.detach()
end

function quick_settings.show()
  client.focus = nil
  quick_settings.screen = mouse.screen
  click_away_handler.attach(quick_settings.hide)
  quick_settings.visible = true
end

return quick_settings

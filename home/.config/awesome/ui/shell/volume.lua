local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

local helpers = require("helpers")

local signal = require("ui.core.signal")
local effect = require("ui.core.signal.effect")
local computed = require("ui.core.signal.computed")
local map = require("ui.core.signal.map")
local track = require("ui.core.signal.track")

local Window = require("ui.window")
local Row = require("ui.widgets").Row
local Flexible = require("ui.widgets").Flexible
local Image = require("ui.widgets").Image
local ProgressBar = require("ui.widgets").ProgressBar
local Text = require("ui.widgets").Text

local volume = signal(0)
local muted = signal(false)
local hovered = signal(false)

local function get_volume_svg()
  if muted:get() or volume:get() == 0 then
    return "volume-x.svg"
  end

  if volume:get() >= 50 then
    return "volume-2.svg"
  elseif volume:get() >= 20 then
    return "volume-1.svg"
  else
    return "volume.svg"
  end
end

local volume_icon = Image {
  image = computed(function()
    return beautiful.icon_path .. get_volume_svg()
  end),
  stylesheet = "* { color:" .. beautiful.fg_normal .. " }",
  forced_width = dpi(18),
  forced_height = dpi(18),
}

local volume_bar = ProgressBar {
  shape = gears.shape.rounded_bar,
  bar_shape = gears.shape.rounded_bar,
  color = beautiful.fg_focus,
  background_color = beautiful.bg_focus,
  max_value = 100,
  value = volume,
  forced_height = dpi(6),
}

local volume_text = Text {
  text = map(volume, tostring),
  halign = "center",
  valign = "center",
  forced_width = dpi(18),
  forced_height = dpi(18),
}

local volume_widget = Window.Popup {
  padding = dpi(18),
  forced_width = dpi(288),
  placement = function(w)
    awful.placement.bottom(w, {
      margins = beautiful.useless_gap * 4,
      honor_workarea = true,
    })
  end,

  Row {
    align_items = "center",
    spacing = dpi(12),

    volume_icon,
    Flexible {
      grow = 1,
      volume_bar,
    },
    volume_text,
  },
}

helpers.window.set_prop(volume_widget, "_ANIMATE", "slide-up")

local hide_volume_widget = gears.timer({
  timeout = 1,
  autostart = false,
  single_shot = true,
  callback = function()
    volume_widget.visible = false
  end,
})

volume_widget.buttons = {
  awful.button({ "Any" }, 3, function()
    volume_widget.visible = false
    hide_volume_widget:stop()
  end),
}

volume_widget:connect_signal("mouse::enter", function()
  hovered:set(true)
end)

volume_widget:connect_signal("mouse::leave", function()
  hovered:set(false)
end)

-- Keep widget visible while hovered
effect(function()
  track(hovered)

  if not volume_widget.visible then
    return
  end

  if hovered:get() then
    hide_volume_widget:stop()
  else
    hide_volume_widget:again()
  end
end)

local volume_script = "wpctl get-volume @DEFAULT_SINK@"

--- @param callback fun(volume: integer, muted: boolean)
local function get_audio_status(callback)
  awful.spawn.easy_async(volume_script, function(stdout)
    local volume_str = stdout:match("([%d.]+)")
    local muted_str = stdout:match("MUTED")

    local v = math.floor(tonumber(volume_str) * 100)
    local m = muted_str ~= nil

    callback(v, m)
  end)
end

awesome.connect_signal("signal::volume", function()
  get_audio_status(function(v, m)
    volume:set(v)
    muted:set(m)

    if volume_widget.visible then
      if not hovered:get() then
        hide_volume_widget:again()
      end
    else
      volume_widget.visible = true
      hide_volume_widget:start()
    end
  end)
end)

local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")

local signal = require("ui.core.signal")
local effect = require("ui.core.signal.effect")
local computed = require("ui.core.signal.computed")
local map = require("ui.core.signal.map")

local widget = require("ui.widgets")

local volume = signal(0)
local muted = signal(false)
local hovered = signal(false)

local function get_volume_svg()
  if muted.value or volume.value == 0 then
    return "volume-x.svg"
  end

  if volume.value >= 50 then
    return "volume-2.svg"
  elseif volume.value >= 20 then
    return "volume-1.svg"
  else
    return "volume.svg"
  end
end

local volume_icon = widget.new({
  image = computed(function()
    return beautiful.icon_path .. get_volume_svg()
  end),
  stylesheet = "* { color:" .. beautiful.fg_normal .. " }",
  forced_width = dpi(18),
  forced_height = dpi(18),
  widget = wibox.widget.imagebox,
})

local volume_bar = widget.new({
  shape = gears.shape.rounded_bar,
  bar_shape = gears.shape.rounded_bar,
  color = beautiful.fg_focus,
  background_color = beautiful.bg_focus,
  max_value = 100,
  value = volume,
  forced_height = dpi(6),
  widget = wibox.widget.progressbar,
})

local volume_text = widget.new({
  text = map(volume, tostring),
  halign = "center",
  valign = "center",
  forced_width = dpi(18),
  forced_height = dpi(18),
  widget = wibox.widget.textbox,
})

local volume_widget = widget.popup({
  margins = dpi(18),
  forced_width = dpi(288),
  placement = function(w)
    awful.placement.bottom(w, {
      margins = beautiful.useless_gap * 4,
      honor_workarea = true,
    })
  end,
  widget = {
    volume_icon,
    {
      {
        volume_bar,
        valign = "center",
        widget = wibox.container.place,
      },
      left = dpi(12),
      right = dpi(12),
      widget = wibox.container.margin,
    },
    volume_text,
    layout = wibox.layout.align.horizontal,
  },
})

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
  hovered.value = true
end)

volume_widget:connect_signal("mouse::leave", function()
  hovered.value = false
end)

-- Keep widget visible while hovered
effect(function()
  if not volume_widget.visible then
    return
  end

  if hovered.value then
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
    volume.value = v
    muted.value = m

    if volume_widget.visible then
      if not hovered.value then
        hide_volume_widget:again()
      end
    else
      volume_widget.visible = true
      hide_volume_widget:start()
    end
  end)
end)

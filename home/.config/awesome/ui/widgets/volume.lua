local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")

local helpers = require("helpers")

local volume_icon = wibox.widget({
  image = beautiful.icon_path .. "volume_up.svg",
  stylesheet = "* { fill:" .. beautiful.fg_normal .. " }",
  forced_width = dpi(20),
  forced_height = dpi(20),
  widget = wibox.widget.imagebox,
})

local volume_bar = wibox.widget({
  shape = gears.shape.rounded_bar,
  bar_shape = gears.shape.rounded_bar,
  color = beautiful.fg_focus,
  background_color = beautiful.bg_focus,
  max_value = 100,
  value = 0,
  forced_height = dpi(6),
  widget = wibox.widget.progressbar,
})

local volume_text = wibox.widget({
  text = "50",
  halign = "center",
  valign = "center",
  forced_width = dpi(20),
  forced_height = dpi(20),
  widget = wibox.widget.textbox,
})

local volume_widget = helpers.ui.popup({
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

-- Keep widget visible while hovered
local hovered = false

volume_widget:connect_signal("mouse::enter", function()
  hovered = true
  hide_volume_widget:stop()
end)

volume_widget:connect_signal("mouse::leave", function()
  hovered = false
  hide_volume_widget:again()
end)

local volume_script = "wpctl get-volume @DEFAULT_SINK@ | sed -e 's/Volume: //'"

--- @param callback fun(volume: integer, muted: boolean)
local function get_audio_status(callback)
  awful.spawn.easy_async_with_shell(volume_script, function(stdout)
    local volume_str = stdout:match("([%d.]+)")
    local muted_str = stdout:match("MUTED")

    local volume = math.floor(tonumber(volume_str) * 100)
    local muted = muted_str ~= nil

    callback(volume, muted)
  end)
end

awesome.connect_signal("signal::volume", function()
  get_audio_status(function(volume, muted)
    if not muted then
      if volume >= 50 then
        volume_icon.image = beautiful.icon_path .. "volume_up.svg"
      elseif volume > 0 then
        volume_icon.image = beautiful.icon_path .. "volume_down.svg"
      else
        volume_icon.image = beautiful.icon_path .. "volume_mute.svg"
      end
    else
      volume_icon.image = beautiful.icon_path .. "volume_off.svg"
    end

    volume_bar.value = volume
    volume_text.text = tostring(volume)

    if volume_widget.visible then
      if not hovered then
        hide_volume_widget:again()
      end
    else
      volume_widget.visible = true
      hide_volume_widget:start()
    end
  end)
end)

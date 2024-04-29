local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
local helpers = require("helpers")
local wibox = require("wibox")

local offsetx = dpi(56)
local offsety = offsetx + dpi(32)

local width = dpi(56)
local bar_height = dpi(90)

-- local screen = mouse.screen
local screen = screen.primary

local volume_bar = wibox.widget({
  widget = wibox.widget.progressbar,
  shape = gears.shape.rounded_bar,
  bar_shape = gears.shape.rounded_bar,
  color = beautiful.fg_focus,
  background_color = beautiful.bg_focus,
  max_value = 100,
  value = 0,
})

local volume_text = wibox.widget({
  text = "50",
  halign = "center",
  valign = "center",
  forced_height = dpi(10),
  widget = wibox.widget.textbox,
})

local volume_widget = awful.popup({
  screen = screen,
  x = screen.geometry.x + offsetx,
  y = screen.geometry.y + offsety,
  visible = false,
  ontop = true,
  widget = {
    {
      {
        {
          {
            volume_bar,
            direction = "east",
            layout = wibox.container.rotate,
          },
          top = dpi(0),
          right = dpi(23),
          left = dpi(23),
          bottom = dpi(0),
          forced_width = width,
          forced_height = bar_height,
          layout = wibox.container.margin,
        },
        volume_text,
        spacing = dpi(20),
        layout = wibox.layout.fixed.vertical,
      },
      top = dpi(20),
      bottom = dpi(20),
      layout = wibox.container.margin,
    },
    bg = beautiful.bg_normal,
    border_color = beautiful.border_color,
    border_width = beautiful.border_width,
    shape = helpers.shape.rounded_rect(beautiful.border_radius),
    widget = wibox.container.background,
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

volume_widget:connect_signal("button::press", function(_, _, _, button)
  if button == 3 then
    volume_widget.visible = false
    hide_volume_widget:stop()
  end
end)

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

awesome.connect_signal("widgets::volume::show", function()
  get_audio_status(function(volume, muted)
    volume_bar.value = volume
    volume_text.text = muted and "x" or tostring(volume)

    -- screen = mouse.screen
    -- volume_widget.screen = screen
    -- volume_widget.x = screen.geometry.x + offsetx
    -- volume_widget.y = screen.geometry.y + offsety

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

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local rounded_rect = require("helpers").rounded_rect

local offsetx = dpi(56)
local offsety = offsetx + dpi(32)

local width = dpi(56)
local bar_height = dpi(90)

local screen = mouse.screen

local volume_widget = wibox({
  screen = screen,
  x = screen.geometry.x + offsetx,
  y = screen.geometry.y + offsety,
  width = width,
  height = bar_height + dpi(70),
  shape = rounded_rect(8),
  visible = false,
  ontop = true,
})

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
  align = "center",
  valign = "center",
  widget = wibox.widget.textbox,
})

local hide_volume_widget = gears.timer({
  timeout = 1,
  autostart = false,
  single_shot = true,
  callback = function()
    volume_widget.visible = false
  end,
})

local buttons = {
  awful.button({}, 3, function(t)
    volume_widget.visible = false
    hide_volume_widget:stop()
  end),
}

volume_widget:setup({
  {
    {
      {
        volume_bar,
        direction = "east",
        layout = wibox.container.rotate,
      },
      top = dpi(20),
      right = dpi(23),
      left = dpi(23),
      bottom = dpi(0),
      forced_height = bar_height + dpi(20),
      layout = wibox.container.margin,
    },
    volume_text,
    buttons = buttons,
    layout = wibox.layout.align.vertical,
  },
  layout = wibox.layout.margin,
})

awesome.connect_signal("volume_change", function()
  awful.spawn.easy_async_with_shell(
    "amixer sget Master | grep 'Right:' | awk -F '[][]' '{print $2}'| sed 's/[^0-9]//g'",
    function(stdout)
      local volume_level = tonumber(stdout)
      volume_bar.value = volume_level
      volume_text.text = tostring(volume_level)
    end,
    false
  )

  screen = mouse.screen
  volume_widget.screen = screen
  volume_widget.x = screen.geometry.x + offsetx
  volume_widget.y = screen.geometry.y + offsety

  if volume_widget.visible then
    hide_volume_widget:again()
  else
    volume_widget.visible = true
    hide_volume_widget:start()
  end
end)

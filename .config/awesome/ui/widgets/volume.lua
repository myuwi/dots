local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")

local offsetx = dpi(56)
local offsety = offsetx + dpi(32)

local width = dpi(56)
local bar_height = dpi(90)

-- local screen = mouse.screen
local screen = screen.primary

local volume_widget = wibox({
  screen = screen,
  x = screen.geometry.x + offsetx,
  y = screen.geometry.y + offsety,
  width = width,
  height = bar_height + dpi(70),
  -- shape = helpers.shape.rounded_rect(8),
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
  halign = "center",
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

local hovered = false
local volume_widget_buttons = {
  awful.button({}, 3, function()
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
    buttons = volume_widget_buttons,
    layout = wibox.layout.align.vertical,
  },
  bg = beautiful.bg_normal,
  border_color = beautiful.border_color,
  border_width = beautiful.widget_border_width,
  shape = helpers.shape.rounded_rect(beautiful.border_radius),
  widget = wibox.container.background,
})

volume_widget:connect_signal("mouse::enter", function()
  hovered = true
  hide_volume_widget:stop()
end)

volume_widget:connect_signal("mouse::leave", function()
  hovered = false
  hide_volume_widget:again()
end)

--- @param callback fun(volume: integer, muted: boolean)
local function get_audio_status(callback)
  local script = "wpctl get-volume @DEFAULT_AUDIO_SINK@ | sed -e 's/Volume: //';"

  awful.spawn.easy_async_with_shell(script, function(stdout)
    local volume_str = stdout:match("([%d.]+)")
    local muted_str = stdout:match("MUTED")

    local volume = math.floor(tonumber(volume_str) * 100)
    local muted = muted_str ~= nil

    callback(volume, muted)
  end)
end

awesome.connect_signal("widgets::show_volume", function()
  get_audio_status(function(volume, muted)
    volume_bar.value = volume
    volume_text.text = muted and "xx" or tostring(volume)

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

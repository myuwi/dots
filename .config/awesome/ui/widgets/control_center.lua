local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local naughty = require("naughty")

local backdrop = require("ui.widgets.backdrop")

local s = screen.primary

local widget_width = dpi(420)
local offsetx = s.geometry.width - dpi(4) - widget_width
local offsety = beautiful.bar_height + dpi(4)

local control_center_widget = awful.popup({
  screen = s,
  x = s.geometry.x + offsetx,
  y = s.geometry.y + offsety,
  visible = false,
  ontop = true,
  bg = beautiful.colors.transparent,
  widget = {
    {
      text = "text",
      halign = "center",
      valign = "center",
      ellipsize = "end",
      widget = wibox.widget.textbox,
    },
    forced_width = widget_width,
    forced_height = dpi(540),
    bg = beautiful.bg_normal,
    border_color = beautiful.border_color,
    border_width = beautiful.widget_border_width,
    shape = helpers.shape.rounded_rect(beautiful.border_radius),
    widget = wibox.container.background,
  },
})

local function show()
  backdrop:show()
  control_center_widget.visible = true
end

local function hide()
  control_center_widget.visible = false
  backdrop:hide()
end

local function toggle()
  if control_center_widget.visible then
    hide()
  else
    show()
  end
end

awesome.connect_signal("widgets::control_panel::show", show)
awesome.connect_signal("widgets::control_panel::hide", hide)
awesome.connect_signal("widgets::control_panel::toggle", toggle)

backdrop:connect_signal("click", function()
  if control_center_widget.visible then
    hide()
  end
end)

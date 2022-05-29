local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local offsetx = dpi(56)
local offsety = offsetx + dpi(32)

local width = dpi(56)
local bar_height = dpi(90)

local screen = mouse.screen

-- create the volume_adjust component
local volume_widget = wibox({
	screen = screen,
	x = screen.geometry.x + offsetx,
	y = screen.geometry.y + offsety,
	width = width,
	height = bar_height + dpi(70),
	shape = gears.shape.rounded_rect,
	visible = false,
	ontop = true,
})

local volume_bar = wibox.widget({
	widget = wibox.widget.progressbar,
	shape = gears.shape.rounded_bar,
	color = beautiful.fg_focus,
	background_color = beautiful.bg_focus,
	max_value = 100,
	value = 0,
})

local volume_text = wibox.widget({
	text = "50%",
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

local buttons = gears.table.join(awful.button({}, 3, function(t)
	volume_widget.visible = false
	hide_volume_widget:stop()
end))

volume_widget:setup({
	layout = wibox.layout.align.vertical,
	{
		wibox.container.margin(volume_bar, dpi(0), dpi(23), dpi(23), dpi(23)),
		forced_height = bar_height + dpi(20),
		direction = "east",
		layout = wibox.container.rotate,
	},
	{
		wibox.container.margin(volume_text, dpi(0), dpi(0), dpi(20), dpi(20)),
		forced_height = dpi(10),
		layout = wibox.layout.align.vertical,
	},
	buttons = buttons,
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

	-- make volume_adjust component visible
	if volume_widget.visible then
		hide_volume_widget:again()
	else
		volume_widget.visible = true
		hide_volume_widget:start()
	end
end)

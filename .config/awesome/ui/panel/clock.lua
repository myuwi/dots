local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local clock = function()
	local widget = wibox.widget({
		{
			format = "%a %b %d, %H:%M",
			widget = wibox.widget.textclock,
		},
		margins = dpi(6),
		widget = wibox.container.margin,
	})

	return widget
end

return clock

local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")

local widget = wibox({ width = screen[mouse.screen].geometry.width })
widget.border_width = 3
widget.ontop = true
widget.visible = false

local get_clients = function()
	local clients = {}

	for _, c in ipairs(client.get(mouse.screen.index)) do
		if c.first_tag == awful.screen.focused().selected_tag then
			table.insert(clients, c)
		end
	end

	return clients
end

-- https://en.wikipedia.org/wiki/Alt-Tab
awesome.connect_signal("window_switcher::open", function()
	local clients = get_clients()

	for _, c in ipairs(clients) do
		naughty.notify({
			title = "Window Switcher",
			text = tostring(c.name),
		})
	end
end)

local awful = require("awful")
local beautiful = require("beautiful")

local function rules(clientkeys, clientbuttons)
	local screen_count = screen.count()
	local leftmost_screen = awful.screen.getbycoord(0, 0)

	return {
		-- All clients will match this rule.
		{
			rule = {},
			properties = {
				border_width = beautiful.border_width,
				border_color = beautiful.border_normal,
				focus = awful.client.focus.filter,
				raise = true,
				keys = clientkeys,
				buttons = clientbuttons,
				screen = awful.screen.preferred,
				placement = awful.placement.no_overlap + awful.placement.no_offscreen,
				-- titlebars_enabled = true,
			},
		},
		-- Floating clients.
		{
			rule_any = {
				instance = {
					"DTA", -- Firefox addon DownThemAll.
					"copyq", -- Includes session name in class.
					"pinentry",
				},
				class = {
					"Arandr",
					"Blueman-manager",
					"Catfish",
					"Gpick",
					"Kruler",
					"MessageWin", -- kalarm.
					"Spacefm",
					"Steam",
					"Thunar",
					"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
					"Wpa_gui",
					"veromix",
					"xtightvncviewer",
					"zoom",
				},
				-- Note that the name property shown in xprop might be set slightly after creation of the client
				-- and the name shown there might not match defined rules here.
				name = {
					"Event Tester", -- xev.
				},
				role = {
					"AlarmWindow", -- Thunderbird's calendar.
					"ConfigManager", -- Thunderbird's about:config.
					"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
				},
			},
			properties = {
				floating = true,
			},
		},
		{
			rule = {
				name = "Discord",
			},
			properties = {
				floating = true,
				width = 1600,
				height = 900,
				screen = leftmost_screen,
				tag = screen_count > 1 and "1" or "9",
			},
		},
		{
			rule = {
				name = "Steam",
			},
			properties = {
				floating = true,
				width = 1600,
				height = 900,
			},
		},
	}
end

return rules

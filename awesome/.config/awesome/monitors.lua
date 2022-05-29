local awful = require("awful")

awful.spawn.easy_async_with_shell("xrandr -q --current | grep ' connected'", function(stdin)
	local command = "xrandr --output DP-0 --primary --mode 1920x1080 --rate 144.00 --pos 0x0"

	if stdin:find("HDMI%-0") then
		command = command .. " --output HDMI-0 --mode 1920x1080 --rate 60.00 --pos 1920x200"
	end

	if stdin:find("DP%-3") then
		command = command .. " --output DP-3 --mode 1920x1080 --rate 60.00 --pos -1920x200"
	end

	awful.spawn.with_shell(command)
end)

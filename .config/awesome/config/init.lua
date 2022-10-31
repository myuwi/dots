local awful = require("awful")
local helpers = require("helpers")

-- Spawn new clients as slaves
client.connect_signal("manage", function(c)
  if not awesome.startup then
    awful.client.setslave(c)

    -- Center windows when they are spawned
    if c.floating and not c.size_hints.user_position and not c.size_hints.program_position then
      helpers.placement.centered(c)
    end
  end

  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Send clients to bottom of the z-order when they are minimized
client.connect_signal("property::minimized", function(c)
  c:lower()
end)

require(... .. ".autostart")
require(... .. ".keybinds")
require(... .. ".monitors")
require(... .. ".rules")
require(... .. ".screens")

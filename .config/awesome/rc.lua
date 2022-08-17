local gears = require("gears")
local naughty = require("naughty")
require("awful.autofocus")

naughty.connect_signal("request::display_error", function(message, startup)
  naughty.notification({
    urgency = "critical",
    title = "An error happened" .. (startup and " during startup!" or "!"),
    message = message,
  })
end)

-- Globals
config_dir = gears.filesystem.get_configuration_dir()
modkey = "Mod4"
apps = {
  terminal = "alacritty",
}

-- Theme
require("theme")

require("daemon")

-- require("module")

-- Config
require("config")

-- UI elements
require("ui")

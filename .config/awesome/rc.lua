local gears = require("gears")
require("awful.autofocus")

-- Globals
config_dir = gears.filesystem.get_configuration_dir()
modkey = "Mod4"
apps = {
  terminal = "alacritty",
}

-- Theme
require("theme")

-- Config
require("config")

-- UI elements
require("ui")

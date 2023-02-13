local naughty = require("naughty")
require("awful.autofocus")

naughty.connect_signal("request::display_error", function(message, startup)
  naughty.notification({
    urgency = "critical",
    title = "An error happened" .. (startup and " during startup!" or "!"),
    message = message,
  })
end)

awesome.connect_signal("debug::deprecation", function(msg)
  naughty.notification({
    urgency = "critical",
    title = "Deprecation notice",
    message = msg,
  })
end)

-- Globals
modkey = "Mod4"
apps = {
  terminal = "alacritty",
}

local ok, vars = pcall(require, "user_variables")
if not ok then
  vars = {}
end
user_variables = vars

-- Theme
require("theme")

-- require("signals")

-- Config
require("config")

-- UI elements
require("ui")

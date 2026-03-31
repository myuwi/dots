local tide = {}

-- Signals (reactive system)

tide.signal = require("tide.signal")

-- Core framework

tide.Widget = require("tide.core.widget")
tide.Window = require("tide.core.window")
tide.Notification = require("tide.core.notification")

-- Widgets

tide.widget = require("tide.widget")

-- Flow control

tide.flow = require("tide.flow")

tide.util = require("tide.util")

return tide

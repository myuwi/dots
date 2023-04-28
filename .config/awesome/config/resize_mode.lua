local awful = require("awful")

-- TODO: create indicator (bar component / widget) for current mode
local function start()
  keygrabber = awful.keygrabber({
    keybindings = {
      awful.key({}, "h", function()
        awful.tag.incmwfact(-0.05)
      end),
      awful.key({}, "j", function()
        -- TODO: use a different method to change client height linearly?
        awful.client.incwfact(-0.05)
      end),
      awful.key({}, "k", function()
        awful.client.incwfact(0.05)
      end),
      awful.key({}, "l", function()
        awful.tag.incmwfact(0.05)
      end),
    },
    stop_key = { "Escape", "Return" },
    stop_event = "press",
    stop_callback = function()
      awesome.emit_signal("resize_mode::exit")
    end,
  })

  awesome.emit_signal("resize_mode::enter")
  keygrabber:start()
end

return start

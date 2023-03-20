local awful = require("awful")
local gobject = require("gears.object")
local wibox = require("wibox")
local helpers = require("helpers")

local backdrop = gobject({})

function backdrop:show()
  for s in screen do
    if s.backdrop_widget then
      s.backdrop_widget.visible = true
    end
  end
end

function backdrop:hide()
  for s in screen do
    if s.backdrop_widget then
      s.backdrop_widget.visible = false
    end
  end
end

-- TODO: use one backdrop widget that covers all screens?
awful.screen.connect_for_each_screen(function(s)
  s.backdrop_widget = wibox({
    screen = s,
    type = "utility",
    x = s.geometry.x,
    y = s.geometry.y,
    width = s.geometry.width,
    height = s.geometry.height,
    bg = "#00000000",
    visible = false,
    ontop = true,
  })

  s.backdrop_widget:buttons( --
    helpers.table.map({ 1, 2, 3 }, function(n)
      return awful.button({ "Any" }, n, function()
        backdrop:emit_signal("click", {
          screen = s,
          button = n,
        })
      end)
    end)
  )
end)

return backdrop

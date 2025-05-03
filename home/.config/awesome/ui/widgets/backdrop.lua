local awful = require("awful")
local wibox = require("wibox")

local helpers = require("helpers")

local backdrop = {}

local backdrop_widget = wibox({
  screen = screen.primary,
  type = "utility",
  x = 0,
  y = 0,
  width = 1,
  height = 1,
  bg = "#00000000",
  visible = false,
  ontop = true,
})

local function update_backdrop_geometry()
  local coords = {}

  for s in screen do
    if not coords.left or coords.left > s.geometry.x then
      coords.left = s.geometry.x
    end

    if not coords.top or coords.top > s.geometry.y then
      coords.top = s.geometry.y
    end

    local sright = s.geometry.x + s.geometry.width
    if not coords.right or coords.right < sright then
      coords.right = sright
    end

    local sbottom = s.geometry.y + s.geometry.height
    if not coords.bottom or coords.bottom < sbottom then
      coords.bottom = sbottom
    end
  end

  backdrop_widget:geometry({
    x = coords.left,
    y = coords.top,
    width = coords.right - coords.left,
    height = coords.bottom - coords.top,
  })
end

screen.connect_signal("property::geometry", update_backdrop_geometry)
update_backdrop_geometry()

---@type function | nil
local cb = nil

backdrop_widget:buttons( --
  helpers.table.map({ 1, 2, 3 }, function(n)
    return awful.button({ "Any" }, n, function()
      if cb then
        cb()
      end
    end)
  end)
)

local function show()
  backdrop_widget.visible = true
end

local function hide()
  backdrop_widget.visible = false
end

---@param callback function
function backdrop.attach(callback)
  cb = callback
  show()
end

function backdrop.detach()
  cb = nil
  hide()
end

return backdrop

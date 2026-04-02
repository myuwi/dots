local awful = require("awful")
local beautiful = require("beautiful")

local helpers = require("helpers")
local Popup = require("ui.popup")
local Calendar = require("ui.components").Calendar

local calendar = Calendar {}

local calendar_popup = Popup {
  placement = function(w)
    awful.placement.top_right(w, {
      margins = beautiful.useless_gap * 2,
      honor_workarea = true,
    })
  end,
  on_click_outside = function(self)
    self.visible = false
  end,
  on_blur = function(self)
    self.visible = false
  end,
  calendar,
}

helpers.window.set_prop(calendar_popup, "_ANIMATE", "slide-down")

-- TODO: Somehow whitelist clock widget in bar to avoid closing and reopening on click
-- TODO: Esc to hide, also refocus client which was unfocused in show()
function calendar_popup.hide()
  calendar_popup.visible = false
end

function calendar_popup.show()
  client.focus = nil
  calendar_popup.screen = mouse.screen
  calendar:reset()
  calendar_popup.visible = true
end

return calendar_popup

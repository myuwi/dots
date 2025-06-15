local awful = require("awful")
local beautiful = require("beautiful")

local helpers = require("helpers")
local Window = require("ui.window")
local Calendar = require("ui.components").Calendar

local calendar = Calendar()

local calendar_popup = Window.Popup {
  placement = function(w)
    awful.placement.top_right(w, {
      margins = beautiful.useless_gap * 2,
      honor_workarea = true,
    })
  end,

  calendar,
}

-- TODO: Somehow whitelist clock widget in bar to avoid closing and reopening on click
local click_away_handler = helpers.ui.create_click_away_handler(calendar_popup, true)

-- TODO: Esc to hide, also refocus client which was unfocused in show()
local function hide()
  calendar_popup.visible = false
  click_away_handler.detach()
end

local function show()
  client.focus = nil
  calendar_popup.screen = mouse.screen
  click_away_handler.attach(hide)
  calendar:reset()
  calendar_popup.visible = true
end

awesome.connect_signal("shell::calendar_popup::show", show)

return calendar_popup

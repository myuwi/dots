local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")

local calendar = require(... .. ".calendar")()

local time_and_date_widget = helpers.ui.popup({
  placement = function(w)
    awful.placement.top_right(w, {
      margins = beautiful.useless_gap * 2,
      honor_workarea = true,
    })
  end,
  widget = {
    calendar,
    layout = wibox.layout.align.vertical,
  },
})

-- TODO: Somehow whitelist clock widget in bar to avoid closing and reopening on click
local click_away_handler = helpers.ui.create_click_away_handler(time_and_date_widget, true)

-- TODO: Esc to hide, also refocus client which was unfocused in show()
local function hide()
  time_and_date_widget.visible = false
  click_away_handler.detach()
end

local function show()
  client.focus = nil
  time_and_date_widget.screen = mouse.screen
  click_away_handler.attach(hide)
  calendar:reset()
  time_and_date_widget.visible = true
end

awesome.connect_signal("widgets::time_and_date::show", show)

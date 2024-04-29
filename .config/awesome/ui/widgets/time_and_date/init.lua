local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")

local calendar = require(... .. ".calendar")()

-- TODO: Don't hardcode to primary screen
local s = screen.primary

-- TODO: make popup with rounded border and margin its own reusable component
local time_and_date_widget = awful.popup({
  screen = s,
  x = s.geometry.x,
  y = s.geometry.y + beautiful.bar_height + beautiful.useless_gap * 4,
  visible = false,
  ontop = true,
  bg = beautiful.colors.transparent,
  widget = {
    {
      {
        calendar,
        layout = wibox.layout.align.vertical,
      },
      margins = 12,
      widget = wibox.container.margin,
    },
    bg = beautiful.bg_normal,
    border_color = beautiful.border_color,
    border_width = beautiful.border_width,
    shape = helpers.shape.rounded_rect(beautiful.border_radius),
    widget = wibox.container.background,
  },
})

local function place_widget()
  awful.placement.top_right(time_and_date_widget, {
    offset = {
      x = -beautiful.useless_gap * 2,
      y = beautiful.useless_gap * 2,
    },
    honor_workarea = true,
  })
end

time_and_date_widget:connect_signal("property::geometry", place_widget)

-- TODO: Somehow whitelist clock widget in bar to avoid closing and reopening on click
local click_away_handler = helpers.ui.create_click_away_handler(time_and_date_widget, true)

local function hide()
  time_and_date_widget.visible = false
  click_away_handler.detach()
end

-- TODO: unfocus client on open?
local function show()
  click_away_handler.attach(hide)
  calendar:reset()
  time_and_date_widget.visible = true
end

awesome.connect_signal("widgets::time_and_date::show", show)

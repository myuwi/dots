local beautiful = require("beautiful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

local button = function(args)
  local args = args or {}
  local text = args.text or ""

  local widget = wibox.widget({
    {
      {
        id = "text_role",
        halign = "center",
        valign = "center",
        font = beautiful.font,
        text = text,
        widget = wibox.widget.textbox,
      },
      left = dpi(8),
      right = dpi(8),
      widget = wibox.container.margin,
    },
    bg = beautiful.colors.overlay,
    forced_height = dpi(28),
    shape = helpers.shape.rounded_rect(beautiful.border_radius),
    widget = wibox.container.background,
  })

  helpers.ui.add_hover_background_fade(widget, beautiful.colors.overlay, beautiful.colors.highlight_med, 0.05)
  helpers.ui.add_hover_cursor(widget, "hand2")

  return widget
end

return button

local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local helpers = require("helpers")

local function button(args)
  args = args or {}
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

  helpers.ui.add_hover_background(widget, helpers.color.lighten(beautiful.colors.overlay, 0.05), 0.05)

  return widget
end

return button

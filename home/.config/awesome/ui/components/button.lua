local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local Container = require("ui.widgets").Container
local Text = require("ui.widgets").Text

local helpers = require("helpers")

---@class (exact) ButtonArgs
---@field text string
---@field buttons? table[]

---@param args ButtonArgs
local function button(args)
  args = args or {}
  local text = args.text or ""

  local widget = Container {
    bg = beautiful.bg_button,
    forced_height = dpi(28),
    padding = { x = dpi(8) },
    radius = beautiful.border_radius,
    buttons = args.buttons,

    Text {
      text = text,
      font = beautiful.font,
      id = "text_role",
      halign = "center",
      valign = "center",
    },
  }

  helpers.ui.add_hover_background(widget, beautiful.bg_button_hover, 0.15)

  return widget
end

return button

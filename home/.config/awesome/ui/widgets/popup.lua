local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local hshape = require("helpers.shape")

---@class (exact) PopupArgs
---@field forced_width integer?
---@field forced_height integer?
---@field margins integer?
---@field screen table?
---@field placement fun(w: table): any
---@field widget table

---@param args PopupArgs
local function popup(args)
  local forced_width = args.forced_width
  local forced_height = args.forced_height
  local margins = args.margins or dpi(12)
  local placement = args.placement
  local s = args.screen or screen.primary
  local widget = args.widget

  local w = awful.popup({
    screen = s,
    ontop = true,
    visible = false,
    bg = beautiful.colors.transparent,
    placement = placement,
    widget = {
      {
        widget,
        margins = margins,
        widget = wibox.container.margin,
      },
      bg = beautiful.bg_normal,
      border_color = beautiful.border_color,
      border_width = beautiful.border_width,
      forced_width = forced_width,
      forced_height = forced_height,
      shape = hshape.rounded_rect(beautiful.border_radius),
      widget = wibox.container.background,
    },
  })

  return w
end

return popup

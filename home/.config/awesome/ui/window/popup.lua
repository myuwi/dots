local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local Container = require("ui.widgets").Container
local Window = require("ui.core.window")

---@class (exact) PopupArgs
---@field forced_width integer?
---@field forced_height integer?
---@field padding integer?
---@field screen table?
---@field placement fun(w: table): any
---@field widget? table
---@field [1]? table

---@param args PopupArgs
local function popup(args)
  local forced_height = args.forced_height
  local forced_width = args.forced_width
  local padding = args.padding or dpi(12)
  local placement = args.placement
  local s = args.screen or screen.primary
  local widget = args.widget or args[1]

  return Window {
    window = awful.popup,
    screen = s,
    ontop = true,
    visible = false,
    placement = placement,
    bg = beautiful.bg_normal,
    border_color = beautiful.border_color,
    border_width = beautiful.border_width,
    radius = beautiful.corner_radius,

    Container {
      forced_height = forced_height,
      forced_width = forced_width,
      padding = padding,
      widget,
    },
  }
end

return popup

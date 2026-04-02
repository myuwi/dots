local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local Window = require("tide.core.window")
local Container = require("tide.widget").Container

---@class (exact) PopupArgs
---@field forced_width integer?
---@field forced_height integer?
---@field padding integer?
---@field screen table?
---@field placement fun(w: table): any
---@field backdrop boolean?
---@field on_click_outside fun(self: table, target: table)?
---@field on_blur fun(self: table)?
---@field widget? table
---@field [1]? table

---@param args PopupArgs
local function Popup(args)
  local forced_height = args.forced_height
  local forced_width = args.forced_width
  local padding = args.padding or dpi(12)
  local placement = args.placement
  local s = args.screen or screen.primary
  local widget = args.widget or args[1]
  local backdrop = args.backdrop
  local on_click_outside = args.on_click_outside
  local on_blur = args.on_blur

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
    backdrop = backdrop,
    on_click_outside = on_click_outside,
    on_blur = on_blur,

    Container {
      forced_height = forced_height,
      forced_width = forced_width,
      padding = padding,
      widget,
    },
  }
end

return Popup

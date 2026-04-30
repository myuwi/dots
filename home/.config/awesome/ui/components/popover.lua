local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local Window = require("tide.core.window")
local Anchor = require("tide.widget").Anchor
local Container = require("tide.widget").Container
local signal = require("tide.signal")

local function Popover(args)
  local open = signal(false)
  local offset = args.offset or beautiful.useless_gap * 2
  local custom_placement = type(args.placement) == "function" and args.placement or nil

  local trigger_geom = { wibox = nil, x = 0, y = 0, width = 0, height = 0 }

  local popup

  local state
  state = {
    open = open,
    show = function()
      client.focus = nil
      popup.screen = (trigger_geom.wibox and trigger_geom.wibox.screen) or mouse.screen
      popup.visible = true
    end,
    hide = function()
      popup.visible = false
    end,
    toggle = function()
      if popup.visible then
        state.hide()
      else
        state.show()
      end
    end,
  }

  local content = args.content
  local resolved_content = type(content) == "function" and content(state) or content

  local function place(p)
    if custom_placement then
      return custom_placement(p)
    end
    if not trigger_geom.wibox then
      return
    end

    local wb = trigger_geom.wibox:geometry()
    local pg = p:geometry()
    local tx = wb.x + trigger_geom.x
    local ty = wb.y + trigger_geom.y

    local px = tx + (trigger_geom.width - pg.width) / 2
    local py = ty + trigger_geom.height + offset

    local sg = p.screen.workarea
    local margin = beautiful.useless_gap * 2
    local border = p.border_width or 0

    local min_x = sg.x + margin
    local max_x = sg.x + sg.width - margin - pg.width - border * 2
    local min_y = sg.y + margin
    local max_y = sg.y + sg.height - margin - pg.height - border * 2

    px = math.max(min_x, math.min(px, max_x))
    py = math.max(min_y, math.min(py, max_y))

    p:geometry({ x = math.floor(px), y = math.floor(py) })
  end

  popup = Window {
    window = awful.popup,
    screen = args.screen or screen.primary,
    ontop = true,
    visible = false,
    placement = place,
    bg = beautiful.bg_normal,
    border_color = beautiful.border_color,
    border_width = beautiful.border_width,
    radius = beautiful.corner_radius,
    backdrop = args.backdrop,
    on_click_outside = function(self)
      self.visible = false
    end,
    on_blur = function(self)
      self.visible = false
    end,

    Container {
      padding = args.padding or dpi(12),
      resolved_content,
    },
  }

  popup:connect_signal("property::visible", function()
    open:set(popup.visible)
    if args.on_open_change then
      args.on_open_change(popup.visible)
    end
  end)

  popup:set_xproperty("_ANIMATE", args.animate or "slide-down")

  local trigger_widget = type(args.trigger) == "function" and args.trigger(state) or args.trigger

  local trigger = Anchor {
    on_anchor_geometry_change = function(geometry)
      trigger_geom.wibox = geometry.wibox
      trigger_geom.x = geometry.x
      trigger_geom.y = geometry.y
      trigger_geom.width = geometry.width
      trigger_geom.height = geometry.height
    end,

    trigger_widget,
  }

  trigger.open = open
  trigger.show = state.show
  trigger.hide = state.hide
  trigger.toggle = state.toggle
  return trigger
end

return Popover

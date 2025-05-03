local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local rubato = require("lib.rubato")

local hcolor = require("helpers.color")
local hmouse = require("helpers.mouse")
local hshape = require("helpers.shape")
local htable = require("helpers.table")

local _M = {}

--- Add a hover background to a widget
--- @param widget table A widget
--- @param hover_color string A color
_M.add_hover_background = function(widget, hover_color)
  local old_bg

  widget:connect_signal("mouse::enter", function()
    if widget.bg ~= hover_color then
      old_bg = widget.bg
    end

    widget.bg = hover_color
  end)

  widget:connect_signal("mouse::leave", function()
    if old_bg then
      widget.bg = old_bg
    end
  end)
end

--- Add a hover background to a widget
--- @param widget table A widget
--- @param normal_color string A color
--- @param hover_color string A color
--- @param transition number A transition duration
_M.add_hover_background_fade = function(widget, normal_color, hover_color, transition)
  local timed = rubato.timed({
    duration = transition,
    subscribed = function(pos)
      local col = hcolor.gradient(normal_color, hover_color, pos)
      widget.bg = col
    end,
  })

  widget:connect_signal("mouse::enter", function()
    timed.target = 1
  end)

  widget:connect_signal("mouse::leave", function()
    timed.target = 0
  end)
end

--- Add a hover cursor to a widget
--- @param widget table A widget
--- @param hover_cursor string A cursor name
_M.add_hover_cursor = function(widget, hover_cursor)
  local default_cursor = "left_ptr"

  widget:connect_signal("mouse::enter", function()
    local w = mouse.current_wibox
    if w then
      w.cursor = hover_cursor
    end
  end)

  widget:connect_signal("mouse::leave", function()
    local w = mouse.current_wibox
    if w then
      w.cursor = default_cursor
    end
  end)
end

--- Colorize some text
--- @param text string
--- @param color string
--- @return string
_M.colorize_text = function(text, color)
  return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

--- Add a click away handler to a widget
--- @param widget table A widget
_M.create_click_away_handler = function(widget, focus_events)
  ---@type fun(target: any) | nil
  local cb = nil

  -- TODO: Ignore notifications, backdrop, etc.?
  local function cb_handler(target, _, _, button)
    if target == widget then
      return
    end

    -- Ignore scroll events
    if type(button) == "number" and button > 3 then
      return
    end

    if cb then
      cb(target)
    end
  end

  local root_binds = htable.map({ 1, 2, 3 }, function(n)
    return awful.button({ "Any" }, n, cb_handler)
  end)

  ---@param callback fun(target: any)
  local function attach(callback)
    cb = callback

    awful.mouse.append_global_mousebindings(root_binds)
    client.connect_signal("button::press", cb_handler)
    wibox.connect_signal("button::press", cb_handler)

    if focus_events then
      client.connect_signal("focus", cb_handler)
      tag.connect_signal("property::selected", cb_handler)
    end
  end

  local function detach()
    cb = nil

    hmouse.remove_global_mousebindings(root_binds)
    client.disconnect_signal("button::press", cb_handler)
    wibox.disconnect_signal("button::press", cb_handler)

    if focus_events then
      client.disconnect_signal("focus", cb_handler)
      tag.disconnect_signal("property::selected", cb_handler)
    end
  end

  return {
    attach = attach,
    detach = detach,
  }
end

---@class (exact) Popup
---@field forced_width integer?
---@field forced_height integer?
---@field margins integer?
---@field screen table?
---@field placement fun(w: table): any
---@field widget table

---@param args Popup
_M.popup = function(args)
  local forced_width = args.forced_width
  local forced_height = args.forced_height
  local margins = args.margins or dpi(12)
  local placement = args.placement
  local s = args.screen or screen.primary
  local widget = args.widget

  local popup = awful.popup({
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

  return popup
end

return _M

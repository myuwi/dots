local awful = require("awful")
local gcolor = require("gears.color")
local wibox = require("wibox")

local rubato = require("lib.rubato")

local hcolor = require("helpers.color")
local hmouse = require("helpers.mouse")
local htable = require("helpers.table")

local M = {}

--- Add a hover background to a widget
--- @param widget table A widget
--- @param hover_color string A color value in hexadecimal
--- @param transition_duration? number A transition duration in seconds
function M.add_hover_background(widget, hover_color, transition_duration)
  transition_duration = transition_duration or 0

  local original_color = gcolor.to_rgba_string(widget.bg) --[[@as string]]

  if transition_duration > 0 then
    local timed = rubato.timed({
      duration = transition_duration,
      subscribed = function(pos)
        local col = hcolor.blend(original_color, hover_color, pos)
        widget.bg = col
      end,
    })

    widget:connect_signal("mouse::enter", function()
      timed.target = 1
    end)

    widget:connect_signal("mouse::leave", function()
      timed.target = 0
    end)
  else
    widget:connect_signal("mouse::enter", function()
      widget.bg = hover_color
    end)

    widget:connect_signal("mouse::leave", function()
      widget.bg = original_color
    end)
  end
end

--- Add a hover cursor to a widget
--- @param widget table A widget
--- @param hover_cursor string A cursor name
function M.add_hover_cursor(widget, hover_cursor)
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
function M.colorize_text(text, color)
  return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

--- Add a click away handler to a widget
--- @param widget table A widget
function M.create_click_away_handler(widget, focus_events)
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

return M

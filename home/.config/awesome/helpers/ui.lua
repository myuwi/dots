local gcolor = require("gears.color")

local rubato = require("rubato")

local hcolor = require("helpers.color")

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

return M

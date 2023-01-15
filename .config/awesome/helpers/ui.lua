local rubato = require("lib.rubato")
local color = require("helpers.color")

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
    intro = 0,
    duration = transition,
    subscribed = function(pos)
      -- FIXME: There's a bug here somewhere
      -- helpers/color.lua:24: bad argument #2 to 'format' (number has no integer representation)
      local col = color.gradient(normal_color, hover_color, pos)
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

return _M

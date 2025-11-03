local wibox = require("wibox")
local gcolor = require("gears.color")
local gtable = require("gears.table")

local text = { mt = {} }

-- Set fg as source and call original draw method
function text:draw(context, cr, width, height)
  if self._private.foreground then
    cr:set_source(self._private.foreground)
  end

  wibox.widget.textbox.draw(self, context, cr, width, height)
end

function text:set_fg(fg)
  if fg then
    self._private.foreground = gcolor(fg)
  else
    self._private.foreground = nil
  end
  self:emit_signal("widget::redraw_needed")
  self:emit_signal("property::fg", fg)
end

function text:get_fg()
  return self._private.foreground
end

local function new(...)
  local ret = wibox.widget.textbox(...)
  ret.widget_name = "Text"

  gtable.crush(ret, text, true)

  return ret
end

function text.mt:__call(...)
  return new(...)
end

return setmetatable(text, text.mt)

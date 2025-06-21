local base = require("wibox.widget.base")
local gtable = require("gears.table")

local flexible = { mt = {} }

function flexible:layout(_, ...)
  if self._private.widget then
    return { base.place_widget_at(self._private.widget, 0, 0, ...) }
  end
  return {}
end

function flexible:fit(context, ...)
  if not self._private.widget then
    return 0, 0
  end
  return base.fit_widget(self, context, self._private.widget, ...)
end

flexible.set_widget = base.set_widget_common

function flexible:get_widget()
  return self._private.widget
end

function flexible:get_children()
  return { self._private.widget }
end

function flexible:set_children(children)
  self:set_widget(children[1])
end

function flexible:reset()
  self:set_widget(nil)
  self:set_grow(0)
  self:set_shrink(1)
end

function flexible:get_grow()
  return self._private.grow
end

function flexible:set_grow(grow)
  self._private.grow = grow

  self:emit_signal("widget::layout_changed")
  self:emit_signal("property::grow")
end

function flexible:get_shrink()
  return self._private.shrink
end

function flexible:set_shrink(shrink)
  self._private.shrink = shrink

  self:emit_signal("widget::layout_changed")
  self:emit_signal("property::shrink")
end

-- TODO: basis prop?
local function new(widget, grow, shrink)
  local ret = base.make_widget(nil, "Flexible", { enable_properties = true })

  gtable.crush(ret, flexible, true)

  ret:set_grow(grow or 0)
  ret:set_shrink(shrink or 1)

  if widget then
    ret:set_widget(widget)
  end

  return ret
end

function flexible.mt:__call(...)
  return new(...)
end

return setmetatable(flexible, flexible.mt)

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
  self:set_expand(false)
end

function flexible:get_flex()
  return self._private.flex
end

function flexible:set_flex(flex)
  self._private.flex = flex

  self:emit_signal("widget::layout_changed")
  self:emit_signal("property::flex")
end

function flexible:get_expand()
  return self._private.expand
end

function flexible:set_expand(expand)
  self._private.expand = expand

  self:emit_signal("widget::layout_changed")
  self:emit_signal("property::expand")
end

local function new(widget, flex, expand)
  local ret = base.make_widget(nil, "Flexible", { enable_properties = true })

  gtable.crush(ret, flexible, true)

  ret:set_flex(flex or 1)
  ret:set_expand(expand or false)

  if widget then
    ret:set_widget(widget)
  end

  return ret
end

function flexible.mt:__call(...)
  return new(...)
end

return setmetatable(flexible, flexible.mt)

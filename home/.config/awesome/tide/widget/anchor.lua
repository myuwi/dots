local base = require("wibox.widget.base")
local gtable = require("gears.table")

local anchor = { mt = {} }

function anchor:draw(context, cr, width, height)
  local matrix = cr:get_matrix()
  local geometry = self._private.anchor_geometry
  local wibox = context.wibox
  local x = matrix.x0
  local y = matrix.y0

  if
    geometry.wibox == wibox
    and geometry.x == x
    and geometry.y == y
    and geometry.width == width
    and geometry.height == height
  then
    return
  end

  geometry.wibox = wibox
  geometry.x = x
  geometry.y = y
  geometry.width = width
  geometry.height = height

  self:emit_signal("property::anchor_geometry", geometry)
end

function anchor:layout(_, ...)
  if self._private.widget then
    return { base.place_widget_at(self._private.widget, 0, 0, ...) }
  end
  return {}
end

function anchor:fit(context, ...)
  if not self._private.widget then
    return 0, 0
  end
  return base.fit_widget(self, context, self._private.widget, ...)
end

anchor.set_widget = base.set_widget_common

function anchor:get_widget()
  return self._private.widget
end

function anchor:get_children()
  return { self._private.widget }
end

function anchor:set_children(children)
  self:set_widget(children[1])
end

function anchor:get_anchor_geometry()
  return self._private.anchor_geometry
end

local function new(widget)
  local ret = base.make_widget(nil, "Anchor", { enable_properties = true })

  gtable.crush(ret, anchor, true)

  ret._private.anchor_geometry = {
    wibox = nil,
    x = 0,
    y = 0,
    width = 0,
    height = 0,
  }

  if widget then
    ret:set_widget(widget)
  end

  return ret
end

function anchor.mt:__call(...)
  return new(...)
end

return setmetatable(anchor, anchor.mt)

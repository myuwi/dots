local gtable = require("gears.table")
local wibox = require("wibox")
local base = wibox.widget.base

local hshape = require("helpers.shape")

local container = { mt = {} }

-- Layout a container layout
function container:layout(_, width, height)
  if self._private.widget then
    local x = self._private.padding.left
    local y = self._private.padding.top
    local w = self._private.padding.right
    local h = self._private.padding.bottom

    local resulting_width = width - x - w
    local resulting_height = height - y - h

    if resulting_width >= 0 and resulting_height >= 0 then
      return { base.place_widget_at(self._private.widget, x, y, resulting_width, resulting_height) }
    end
  end
end

-- Fit a container layout into the given space
function container:fit(context, width, height)
  local extra_w = self._private.padding.left + self._private.padding.right
  local extra_h = self._private.padding.top + self._private.padding.bottom
  local w, h = 0, 0
  if self._private.widget then
    w, h = base.fit_widget(self, context, self._private.widget, width - extra_w, height - extra_h)
  end

  if self._private.draw_empty == false and (w == 0 or h == 0) then
    return 0, 0
  end

  return w + extra_w, h + extra_h
end

function container:set_radius(radius)
  self.shape = radius and hshape.rounded_rect(radius)
end

-- TODO: container:get_radius?

local function parse_layer_def(layer)
  if type(layer) == "number" then
    return {
      top = layer,
      right = layer,
      left = layer,
      bottom = layer,
    }
  end

  local top = layer.top or layer.y or layer.rest or 0
  local right = layer.right or layer.x or layer.rest or 0
  local left = layer.left or layer.x or layer.rest or 0
  local bottom = layer.bottom or layer.y or layer.rest or 0

  return {
    top = top,
    right = right,
    left = left,
    bottom = bottom,
  }
end

function container:set_padding(padding)
  self._private.padding = parse_layer_def(padding)

  self:emit_signal("widget::layout_changed")
  self:emit_signal("property::padding")
end

function container:get_padding()
  return self._private.padding
end

-- TODO: border_strategy = "inner"
-- TODO: margin
local function new()
  local ret = wibox.container.background()
  ret.widget_name = "Container"

  gtable.crush(ret, container, true)

  ret._private.padding = parse_layer_def(0)

  return ret
end

function container.mt:__call()
  return new()
end

return setmetatable(container, container.mt)

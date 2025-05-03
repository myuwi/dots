local base = require("wibox.widget.base")
local fixed = require("wibox.layout.fixed")
local gmath = require("gears.math")
local gtable = require("gears.table")

local fit = {}

--- Place child widgets into the layout
---@param context table The context in which we are fit.
---@param width number The available width.
---@param height number The available height.
function fit:layout(context, width, height)
  local result = {}
  local num = #self._private.widgets

  local spacing = self._private.spacing
  local spacing_widget = self._private.spacing_widget
  local abspace = math.abs(spacing)
  local spoffset = spacing < 0 and 0 or spacing
  local total_spacing = (spacing * (num - 1))

  local max_widget_size = self._private.max_widget_size

  local is_y = self._private.dir == "y"
  local is_x = not is_y

  local main_space = is_y and height or width
  local space_per_item = main_space / num - total_spacing / num

  if max_widget_size then
    space_per_item = math.min(space_per_item, max_widget_size)
  end

  ---@class WidgetSize
  ---@field w number
  ---@field h number

  -- Calculate preferred size for each widget
  ---@type WidgetSize[]
  local widget_sizes = {}
  local total_size = 0
  for i, widget in pairs(self._private.widgets) do
    local w, h = base.fit_widget(self, context, widget, width, height)

    if is_y then
      if max_widget_size then
        h = math.min(h, max_widget_size)
      end
      total_size = total_size + h
    else
      if max_widget_size then
        w = math.min(w, max_widget_size)
      end
      total_size = total_size + w
    end

    widget_sizes[i] = { w = w, h = h }
  end

  local main_axis_overflows = total_size + total_spacing > main_space

  -- Resize widgets if main axis overflows
  if main_axis_overflows then
    local total_size_small = 0
    local num_small = 0
    ---@type table<integer, boolean>
    local is_small = {}

    local resizing_needed = true

    -- Distribute available space to widgets
    while resizing_needed do
      resizing_needed = false

      for i, widget_size in ipairs(widget_sizes) do
        local size = is_y and widget_size.h or widget_size.w

        if max_widget_size then
          size = math.min(size, max_widget_size)
        end

        if size < space_per_item and not is_small[i] then
          total_size_small = total_size_small + size
          num_small = num_small + 1
          is_small[i] = true
          resizing_needed = true
        end
      end

      local small_items_spacing = num_small * spacing
      local shared_space = main_space - (total_size_small + small_items_spacing)
      local num_big_items = num - num_small

      space_per_item = shared_space / num_big_items - (total_spacing - small_items_spacing) / num_big_items
    end
  end

  local pos, pos_rounded = 0, 0
  for i, widget in pairs(self._private.widgets) do
    local x, y, w, h

    local main_size = is_y and widget_sizes[i].h or widget_sizes[i].w

    local next_pos
    if main_axis_overflows then
      next_pos = pos + math.min(main_size, space_per_item)
    else
      next_pos = pos + main_size
    end

    local next_pos_rounded = gmath.round(next_pos)

    if is_y then
      x, y = 0, pos_rounded
      w, h = width, next_pos_rounded - pos_rounded
    else
      x, y = pos_rounded, 0
      w, h = next_pos_rounded - pos_rounded, height
    end

    pos = next_pos + spacing
    pos_rounded = next_pos_rounded + spacing

    table.insert(result, base.place_widget_at(widget, x, y, w, h))

    if i > 1 and spacing ~= 0 and spacing_widget then
      table.insert(
        result,
        base.place_widget_at(
          spacing_widget,
          is_x and (x - spoffset) or x,
          is_y and (y - spoffset) or y,
          is_x and abspace or w,
          is_y and abspace or h
        )
      )
    end
  end

  return result
end

--- Fit the layout into the given space.
---@param context table The context in which we are fit.
---@param width number The available width.
---@param height number The available height.
function fit:fit(context, width, height)
  local is_y = self._private.dir == "y"
  local total_spacing = self._private.spacing * (#self._private.widgets - 1)

  local used_in_dir = 0
  local used_in_other = 0

  for _, v in pairs(self._private.widgets) do
    local w, h = base.fit_widget(self, context, v, width, height)

    local max = is_y and w or h
    if max > used_in_other then
      used_in_other = max
    end

    local size_in_dir = is_y and h or w

    if self._private.max_widget_size then
      size_in_dir = math.min(size_in_dir, self._private.max_widget_size)
    end

    used_in_dir = used_in_dir + size_in_dir
  end

  used_in_dir = math.min(used_in_dir, is_y and height or width)

  if is_y then
    return used_in_other, used_in_dir + total_spacing
  end
  return used_in_dir + total_spacing, used_in_other
end

--- Set the maximum size the widgets in this layout will take.
---@param val number
function fit:set_max_widget_size(val)
  if self._private.max_widget_size ~= val then
    self._private.max_widget_size = val
    self:emit_signal("widget::layout_changed")
    self:emit_signal("property::max_widget_size", val)
  end
end

local function get_layout(dir, ...)
  local ret = fixed[dir](...)

  gtable.crush(ret, fit, true)

  ret._private.fill_space = nil

  return ret
end

--- Creates and returns a new horizontal flex layout.
function fit.horizontal(...)
  return get_layout("horizontal", ...)
end

--- Creates and returns a new vertical flex layout.
function fit.vertical(...)
  return get_layout("vertical", ...)
end

return fit

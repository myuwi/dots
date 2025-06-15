local base = require("wibox.widget.base")
local fixed = require("wibox.layout.fixed")
local gtable = require("gears.table")

local flex = {}

-- TODO: implement flexible

---Layout a flex layout. Each widget gets just the space it asks for.
---@param context table The context in which we are drawn.
---@param width number The available width.
---@param height number The available height.
---@return table[]
function flex:layout(context, width, height)
  local result = {}
  local is_y = self._private.dir == "y"
  local is_x = not is_y
  local spacing = self._private.spacing or 0
  local spoffset = math.max(spacing, 0)
  local spinset = math.min(spacing, 0)
  local abspace = math.abs(spacing)
  local spacing_widget = spacing ~= 0 and self._private.spacing_widget or nil
  local max_widget_size = self._private.max_widget_size or math.huge

  local x, y = 0, 0

  for index, widget in pairs(self._private.widgets) do
    local w, h, local_spacing = width - x, height - y, spoffset

    -- Some widget might be zero sized either because this is their
    -- minimum space or just because they are really empty. In this case,
    -- they must still be added to the layout. Otherwise, if their size
    -- change and this layout is resizable, they are lost "forever" until
    -- a full relayout is called on this fixed layout object.
    local zero = false

    if is_y then
      h = select(2, base.fit_widget(self, context, widget, w, h))
      h = math.min(h, max_widget_size)
      zero = h == 0
    else
      w = select(1, base.fit_widget(self, context, widget, w, h))
      w = math.min(w, max_widget_size)
      zero = w == 0
    end

    if zero then
      local_spacing = 0
    end

    -- Add the spacing and spacing widget (if needed)
    if index > 1 then
      if spacing_widget then
        table.insert(
          result,
          base.place_widget_at(
            spacing_widget,
            is_x and (x + spinset) or x,
            is_y and (y + spinset) or y,
            is_x and abspace or w,
            is_y and abspace or h
          )
        )
      end

      x = is_x and x + local_spacing or x
      y = is_y and y + local_spacing or y

      if x >= width or y >= height then
        break
      end
    end

    -- Place widget, even if it has zero width/height. Otherwise
    -- any layout change for zero-sized widget would become invisible.
    table.insert(result, base.place_widget_at(widget, x, y, w, h))

    x = is_x and x + w or x
    y = is_y and y + h or y

    if x >= width or y >= height then
      break
    end
  end

  return result
end

---Fit the flex layout into the given space.
---@param context table The context in which we are fit.
---@param orig_width number The available width.
---@param orig_height number The available height.
---@return number, number
function flex:fit(context, orig_width, orig_height)
  local width_left, height_left = orig_width, orig_height
  local is_y = self._private.dir == "y"
  local spacing = self._private.spacing or 0
  local spoffset = math.max(spacing, 0)
  local max_widget_size = self._private.max_widget_size or math.huge

  -- when no widgets exist the function can be called with orig_width or
  -- orig_height equal to nil. Exit early in this case.
  if #self._private.widgets == 0 then
    return 0, 0
  end

  local used_max = 0
  local fitted_widgets = 0

  for _, v in pairs(self._private.widgets) do
    local w, h = base.fit_widget(self, context, v, width_left, height_left)
    local max

    -- Skip zero sized widgets
    if (is_y and h == 0) or (not is_y and w == 0) then
      goto continue
    end

    -- Add spacing if not the first visible widget
    if fitted_widgets > 0 then
      if is_y then
        height_left = height_left - spoffset
      else
        width_left = width_left - spoffset
      end
    end

    if is_y then
      max = w
      height_left = height_left - math.min(h, max_widget_size)
    else
      max = h
      width_left = width_left - math.min(w, max_widget_size)
    end

    if max > used_max then
      used_max = max
    end

    fitted_widgets = fitted_widgets + 1

    -- Break early if there's no more room left
    if width_left <= 0 or height_left <= 0 then
      if is_y then
        height_left = math.max(height_left, 0)
      else
        width_left = math.max(width_left, 0)
      end
      break
    end

    ::continue::
  end

  if is_y then
    return used_max, orig_height - height_left
  end

  return orig_width - width_left, used_max
end

---Set the maximum size the widgets in this layout will take.
---@param val number
function flex:set_max_widget_size(val)
  if self._private.max_widget_size ~= val then
    self._private.max_widget_size = val
    self:emit_signal("widget::layout_changed")
    self:emit_signal("property::max_widget_size", val)
  end
end

local function get_layout(dir, ...)
  local ret = fixed[dir](...)

  gtable.crush(ret, flex, true)

  ret._private.fill_space = nil

  return ret
end

--- Creates and returns a new horizontal flex layout.
function flex.horizontal(...)
  return get_layout("horizontal", ...)
end

--- Creates and returns a new vertical flex layout.
function flex.vertical(...)
  return get_layout("vertical", ...)
end

return flex

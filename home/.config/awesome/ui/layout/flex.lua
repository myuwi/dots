local base = require("wibox.widget.base")
local fixed = require("wibox.layout.fixed")
local gtable = require("gears.table")

local flex = {}

---Fit the flex layout into the given space.
---@param context table The context in which we are fit.
---@param orig_width number The available width.
---@param orig_height number The available height.
---@return number, number
function flex:fit(context, orig_width, orig_height)
  local width_left, height_left = orig_width, orig_height
  local spacing = self._private.spacing or 0
  local is_y = self._private.dir == "y"
  local used_max = 0

  -- when no widgets exist the function can be called with orig_width or
  -- orig_height equal to nil. Exit early in this case.
  if #self._private.widgets == 0 then
    return 0, 0
  end

  local fitted_widgets = 0

  for _, v in pairs(self._private.widgets) do
    local w, h = base.fit_widget(self, context, v, width_left, height_left)
    local max

    if not v._private.visible then
      goto continue
    end

    -- Add Spacing if not the first visible widget
    if fitted_widgets > 0 then
      if is_y then
        height_left = height_left - spacing
      else
        width_left = width_left - spacing
      end
    end

    if is_y then
      max = w
      height_left = height_left - h
    else
      max = h
      width_left = width_left - w
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

--- Set the maximum size the widgets in this layout will take.
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

local base = require("wibox.widget.base")
local fixed = require("wibox.layout.fixed")
local gmath = require("gears.math")
local gtable = require("gears.table")

local flex = {}

-- TODO: Use the same strategy for sizing widgets as the fit layout? flex_strategy = "smart" prop?
-- TODO: align and justify props

---Layout a flex layout. Each normal widget gets just the space it asks for, while flexible widgets may grow and shrink based on the available space.
---@param context table The context in which we are drawn.
---@param width number The available width.
---@param height number The available height.
---@return table[]
function flex:layout(context, width, height)
  local result = {}
  local is_y = self._private.dir == "y"
  local is_x = not is_y
  local spacing = self._private.spacing or 0
  local spacing_widget = spacing ~= 0 and self._private.spacing_widget or nil
  local max_widget_size = self._private.max_widget_size or math.huge

  -- Calculate flex sizes
  local fixed_size = 0
  local flex_size = 0
  local total_spacing = 0
  local expanded_count = 0

  for _, widget in pairs(self._private.widgets) do
    local w, h = base.fit_widget(self, context, widget, width, height)
    local main_size = is_y and h or w
    main_size = math.min(main_size, max_widget_size)

    if spacing > 0 and main_size > 0 and (fixed_size > 0 or flex_size > 0) then
      total_spacing = total_spacing + spacing
    end

    local flexible = widget.flex ~= nil and widget.flex ~= 0
    local expanded = widget.expand
    if flexible then
      flex_size = flex_size + main_size
      if expanded then
        expanded_count = expanded_count + 1
      end
    else
      fixed_size = fixed_size + main_size
    end
  end

  local flex_space = (is_y and height or width) - fixed_size - total_spacing
  local empty_space = math.max((is_y and height or width) - fixed_size - flex_size - total_spacing, 0)

  -- TODO: flex factor per widget based on widget's flex prop
  local flex_factor = flex_size ~= 0 and math.min(flex_space / flex_size, 1) or 1

  -- Place widgets
  local pos, pos_rounded = 0, 0
  for i, widget in pairs(self._private.widgets) do
    local w, h = base.fit_widget(self, context, widget, width, height)
    local main_size = is_y and h or w
    main_size = math.min(main_size, max_widget_size)

    -- Add the spacing and spacing widget, and add spacing to pos (if needed)
    if i > 1 then
      local local_spacing = (pos > 0 and main_size > 0) and spacing or 0

      -- Add spacing widget when defined
      -- TODO: is it necessary to always add the spacing widget? fixed layout does this, but why?
      if spacing_widget then
        local spinset = math.min(local_spacing, 0)
        local abspace = math.abs(local_spacing)

        table.insert(
          result,
          base.place_widget_at(
            spacing_widget,
            is_x and (pos_rounded + spinset) or 0,
            is_y and (pos_rounded + spinset) or 0,
            is_x and abspace or width,
            is_y and abspace or height
          )
        )
      end

      -- Add spacing to pos if needed
      if local_spacing > 0 then
        pos = pos + local_spacing
        pos_rounded = pos_rounded + local_spacing

        if is_x and pos >= width or is_y and pos >= height then
          break
        end
      end
    end

    -- TODO: replace with grow and shrink props for more fine-grained control?
    local flexible = widget.flex ~= nil and widget.flex ~= 0
    local expanded = widget.expand

    if flexible then
      if empty_space > 0 then
        if expanded then
          main_size = math.min(main_size + empty_space / expanded_count, max_widget_size)
        end
      else
        main_size = main_size * flex_factor
      end
    end

    -- Disallow overflow
    -- TODO: Should this behavior be manually opted into by wrapping an element with `Flexible`? If yes, use unbounded main axis for size calc.
    main_size = math.min(main_size, (is_y and height or width) - pos)

    next_pos = pos + main_size
    next_pos_rounded = gmath.round(next_pos)

    -- Place widget, even if it has zero width/height. Otherwise
    -- any layout change for zero-sized widget would become invisible.
    table.insert(
      result,
      base.place_widget_at(
        widget,
        is_x and pos_rounded or 0,
        is_y and pos_rounded or 0,
        is_x and next_pos_rounded - pos_rounded or width,
        is_y and next_pos_rounded - pos_rounded or height
      )
    )

    pos = next_pos
    pos_rounded = next_pos_rounded

    if is_x and pos >= width or is_y and pos >= height then
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
  local is_y = self._private.dir == "y"
  local is_x = not is_y
  local spacing = self._private.spacing or 0
  local max_widget_size = self._private.max_widget_size or math.huge

  -- when no widgets exist the function can be called with orig_width or
  -- orig_height equal to nil. Exit early in this case.
  if #self._private.widgets == 0 then
    return 0, 0
  end

  local main_axis_left = is_y and orig_height or orig_width
  local cross_axis_max = 0
  local fitted_widgets = 0

  local flexible_size = 0

  for _, widget in pairs(self._private.widgets) do
    local w, h = base.fit_widget(
      self,
      context,
      widget,
      is_x and main_axis_left or orig_width,
      is_y and main_axis_left or orig_height
    )
    local main_axis = is_y and h or w
    local cross_axis = is_y and w or h
    local flexible = widget.flex ~= nil
    local expanded = widget.expand

    -- Skip zero sized widgets
    if main_axis == 0 then
      goto continue
    end

    -- Add spacing if not the first visible widget
    if fitted_widgets > 0 and spacing > 0 then
      main_axis_left = main_axis_left - spacing
    end

    if flexible then
      flexible_size = flexible_size + (expanded and max_widget_size or math.min(main_axis, max_widget_size))
    else
      main_axis_left = main_axis_left - math.min(main_axis, max_widget_size)
    end

    if cross_axis > cross_axis_max then
      cross_axis_max = cross_axis
    end

    fitted_widgets = fitted_widgets + 1

    -- Break early if there's no more room left
    if main_axis_left <= 0 then
      break
    end

    ::continue::
  end

  main_axis_left = math.max(main_axis_left - flexible_size, 0)

  if is_y then
    return cross_axis_max, orig_height - main_axis_left
  end

  return orig_width - main_axis_left, cross_axis_max
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
  ret.widget_name = "Flex"

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

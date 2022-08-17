---------------------------------------------------------------------------
-- A `flex` layout may be initialized with any number of child widgets, and
-- during runtime widgets may be added and removed dynamically.
--
-- On the main axis, the layout will divide the available space evenly between
-- all child widgets, without any regard to how much space these widgets might
-- be asking for.
--
-- Just like @{wibox.layout.fixed}, `flex` allows adding spacing between the
-- widgets, either as an ofset via @{spacing} or with a
-- @{spacing_widget}.
--
-- On its secondary axis, the layout's size is determined by the largest child
-- widget. Smaller child widgets are then placed with the same size.
-- Therefore, child widgets may ignore their `forced_width` or `forced_height`
-- properties for vertical and horizontal layouts respectively.
--
--@DOC_wibox_layout_defaults_flex_EXAMPLE@
-- @author Uli Schlachter
-- @copyright 2010 Uli Schlachter
-- @layoutmod wibox.layout.flex
-- @supermodule wibox.layout.fixed
---------------------------------------------------------------------------

local base = require("wibox.widget.base")
local fixed = require("wibox.layout.fixed")
local table = table
local pairs = pairs
local gmath = require("gears.math")
local gtable = require("gears.table")

local fit = {}

-- {{{ Override inherited properties we want to hide

--- From `wibox.layout.fixed`.
-- @property fill_space
-- @tparam boolean fill_space
-- @propemits true false
-- @hidden

-- }}}

--- Add some widgets to the given fixed layout.
--
-- @tparam widget ... Widgets that should be added (must at least be one).
-- @method add
-- @interface layout

--- Remove a widget from the layout.
--
-- @tparam index The widget index to remove.
-- @treturn boolean index If the operation is successful.
-- @method remove
-- @interface layout

--- Remove one or more widgets from the layout.
--
-- The last parameter can be a boolean, forcing a recursive seach of the
-- widget(s) to remove.
--
-- @tparam widget ... Widgets that should be removed (must at least be one).
-- @treturn boolean If the operation is successful.
-- @method remove_widgets
-- @interface layout

--- Insert a new widget in the layout at position `index`.
--
-- @tparam number index The position
-- @tparam widget widget The widget
-- @treturn boolean If the operation is successful
-- @method insert
-- @emits widget::inserted
-- @emitstparam widget::inserted widget self The layout.
-- @emitstparam widget::inserted widget widget The inserted widget.
-- @emitstparam widget::inserted number count The widget count.
-- @interface layout

--- A widget to insert as a separator between child widgets.
--
-- If this property is a valid widget and @{spacing} is greater than `0`, a
-- copy of this widget is inserted between each child widget, with its size in
-- the layout's main direction determined by @{spacing}.
--
-- By default no widget is used and any @{spacing} is applied as an empty offset.
--
--@DOC_wibox_layout_flex_spacing_widget_EXAMPLE@
--
-- @property spacing_widget
-- @tparam widget spacing_widget
-- @propemits true false
-- @interface layout

--- The amount of space inserted between the child widgets.
--
-- If a @{spacing_widget} is defined, this value is used for its size.
--
--@DOC_wibox_layout_flex_spacing_EXAMPLE@
--
-- @property spacing
-- @tparam number spacing Spacing between widgets.
-- @propemits true false
-- @interface layout

function fit:layout(context, width, height)
  local result = {}
  local spacing = self._private.spacing
  local num = #self._private.widgets
  local total_spacing = (spacing * (num - 1))
  local spacing_widget = self._private.spacing_widget
  local max_widget_size = self._private.max_widget_size
  local abspace = math.abs(spacing)
  local spoffset = spacing < 0 and 0 or spacing
  local is_y = self._private.dir == "y"
  local is_x = not is_y

  local space_per_item
  if is_y then
    space_per_item = height / num - total_spacing / num
  else
    space_per_item = width / num - total_spacing / num
  end

  if max_widget_size then
    space_per_item = math.min(space_per_item, max_widget_size)
  end

  local widget_sizes = {}
  local total_size = 0

  for i, widget in pairs(self._private.widgets) do
    local w, h = base.fit_widget(self, context, widget, width, height)

    if is_x then
      if max_widget_size then
        w = math.min(w, max_widget_size)
      end
      total_size = total_size + w
    else
      if max_widget_size then
        h = math.min(h, max_widget_size)
      end
      total_size = total_size + h
    end

    widget_sizes[i] = {
      w = w,
      h = h,
    }
  end

  local resizing_needed = total_size + total_spacing > width

  local total_size_small = 0
  local num_small = 0
  local is_small = {}

  -- Calculate widget sizes
  if resizing_needed then
    local found_new = false

    repeat
      found_new = false
      for i, widget_size in ipairs(widget_sizes) do
        local w, h = widget_size.w, widget_size.h

        local size = is_x and w or h

        if max_widget_size then
          size = math.min(size, max_widget_size)
        end

        if size < space_per_item and is_small[i] == nil then
          total_size_small = total_size_small + size
          num_small = num_small + 1
          is_small[i] = true
          found_new = true
        end
      end

      local small_items_spacing = num_small * spacing
      local shared_space = width - (total_size_small + small_items_spacing)
      local num_big_items = num - num_small

      space_per_item = shared_space / num_big_items - (total_spacing - small_items_spacing) / num_big_items
    until found_new == false
  end

  local pos, pos_rounded = 0, 0
  for i, widget in pairs(self._private.widgets) do
    local x, y, w, h

    local main_size = is_x and widget_sizes[i].w or widget_sizes[i].h

    local next_pos
    if resizing_needed then
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

-- Fit the flex layout into the given space.
-- @param context The context in which we are fit.
-- @param orig_width The available width.
-- @param orig_height The available height.
function fit:fit(context, orig_width, orig_height)
  local used_in_dir = 0
  local used_in_other = 0

  -- Figure out the maximum size we can give out to sub-widgets
  local sub_height = self._private.dir == "x" and orig_height or orig_height / #self._private.widgets
  local sub_width = self._private.dir == "y" and orig_width or orig_width / #self._private.widgets

  for _, v in pairs(self._private.widgets) do
    local w, h = base.fit_widget(self, context, v, sub_width, sub_height)

    local max = self._private.dir == "y" and w or h
    if max > used_in_other then
      used_in_other = max
    end

    used_in_dir = used_in_dir + (self._private.dir == "y" and h or w)
  end

  if self._private.max_widget_size then
    used_in_dir = math.min(used_in_dir, #self._private.widgets * self._private.max_widget_size)
  end

  local spacing = self._private.spacing * (#self._private.widgets - 1)

  if self._private.dir == "y" then
    return used_in_other, used_in_dir + spacing
  end
  return used_in_dir + spacing, used_in_other
end

--- Set the maximum size the widgets in this layout will take.
--
--That is, maximum width for horizontal and maximum height for vertical.
--
-- @property max_widget_size
-- @tparam number max_widget_size
-- @propemits true false

function fit:set_max_widget_size(val)
  if self._private.max_widget_size ~= val then
    self._private.max_widget_size = val
    self:emit_signal("widget::layout_changed")
    self:emit_signal("property::max_widget_size", val)
  end
end

local function get_layout(dir, widget1, ...)
  local ret = fixed[dir](widget1, ...)

  gtable.crush(ret, fit, true)

  ret._private.fill_space = nil

  return ret
end

--- Creates and returns a new horizontal flex layout.
--
-- @tparam widget ... Widgets that should be added to the layout.
-- @constructorfct wibox.layout.flex.horizontal
function fit.horizontal(...)
  return get_layout("horizontal", ...)
end

--- Creates and returns a new vertical flex layout.
--
-- @tparam widget ... Widgets that should be added to the layout.
-- @constructorfct wibox.layout.flex.vertical
function fit.vertical(...)
  return get_layout("vertical", ...)
end

--@DOC_fixed_COMMON@

return fit

local gtable = require("gears.table")
local wibox = require("wibox")

local Signal = require("ui.core.signal")
local effect = require("ui.core.signal.effect")
local util = require("ui.core.util")

---@class Widget
local Widget = {}

---@return boolean
local function is_widget(obj)
  return type(obj) == "table" and (obj.widget or obj.layout or rawget(obj, "is_widget"))
end

local function set_children(self, new_children)
  if not new_children then
    new_children = {}
  elseif is_widget(new_children) then
    new_children = { new_children }
  end

  if self._private.mount_count and self._private.mount_count > 0 then
    for _, child in ipairs(new_children) do
      for _, child_old in ipairs(self.children) do
        if child == child_old then
          goto continue
        end
      end

      child:emit_signal("mount")

      ::continue::
    end

    for _, child in ipairs(self.children) do
      for _, child_new in ipairs(new_children) do
        if child == child_new then
          goto continue
        end
      end

      child:emit_signal("unmount")

      ::continue::
    end
  end

  return new_children
end

-- TODO: Add typedef
function Widget.new(args)
  if rawget(args, "is_widget") then
    return args
  end

  args.widget = args.widget or args.layout

  local widget = wibox.widget.base.make_widget_declarative({
    widget = args.widget,
  })

  args.widget, args.layout = nil, nil

  gtable.crush(widget, Widget, true)

  -- TODO: special handling for add, reset, etc.?
  util.wrap(widget, "set_children", set_children)

  ---@type table<string, Signal>
  local signals = {}

  local function attach_signals()
    local effect_cleanups = {}

    for k, sig in pairs(signals) do
      effect_cleanups[k] = effect(function()
        widget[k] = sig.value
      end)
    end

    local function detach_signals()
      for _, dispose in pairs(effect_cleanups) do
        dispose()
      end
    end

    return detach_signals
  end

  local cleanup

  local children = {}

  -- TODO: reactive children?
  for key, value in pairs(args) do
    if Signal.is_signal(value) then
      ---@cast value Signal
      if type(key) == "string" then
        signals[key] = value
      end
    elseif is_widget(value) then
      children[#children + 1] = Widget.new(value)
    else
      widget[key] = value
    end
  end

  widget.children = children

  -- Keep track of how many times this widget (instance) is shown on the UI to (un)subscribe signals
  widget._private.mount_count = 0

  widget:connect_signal("mount", function()
    if widget._private.mount_count == 0 then
      cleanup = attach_signals()
    end

    widget._private.mount_count = widget._private.mount_count + 1

    for _, value in ipairs(widget.children) do
      value:emit_signal("mount")
    end
  end)

  widget:connect_signal("unmount", function()
    widget._private.mount_count = widget._private.mount_count - 1

    if widget._private.mount_count == 0 and cleanup then
      cleanup()
      cleanup = nil
    end

    for _, value in ipairs(widget.children) do
      value:emit_signal("unmount")
    end
  end)

  return widget
end

return Widget

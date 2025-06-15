local awful = require("awful")
local wibox = require("wibox")

local Signal = require("ui.core.signal")
local effect = require("ui.core.signal.effect")
local untracked = require("ui.core.signal.untracked")
local util = require("ui.core.util")

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

---@type table[]?
local click_targets

wibox.connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    click_targets = mouse.current_widgets
  end
end)

local function release_handler(...)
  ---@type table[]?
  local release_targets = mouse.current_widgets

  if click_targets and release_targets then
    for i = #release_targets, 1, -1 do
      local target = release_targets[i]
      if target._private.clickable and target == click_targets[i] then
        target:emit_signal("click", ...)
      end
    end
  end

  click_targets = nil
end

awful.mouse.append_global_mousebinding(awful.button({ "Any" }, 1, nil, release_handler))
-- TODO: does seemingly nothing
-- client.connect_signal("button::release", release_handler)
wibox.connect_signal("button::release", release_handler)

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

  -- TODO: special handling for add, reset, etc.?
  util.wrap(widget, "set_children", set_children)

  ---@type table<string, Signal>
  local signals = {}

  local function bind_signals()
    return untracked(function()
      return effect(function()
        for k, sig in pairs(signals) do
          effect(function()
            widget[k] = sig.value
          end)
        end
      end)
    end)
  end

  local cleanup

  local children = {}

  -- TODO: reassigning signals
  -- TODO: on_click_away?
  -- TODO: reactive children?
  for key, value in pairs(args) do
    if Signal.is_signal(value) then
      ---@cast value Signal
      if type(key) == "string" then
        signals[key] = value
      end
    elseif key == "children" then
      children = value
    elseif type(key) == "number" and is_widget(value) then
      children[#children + 1] = Widget.new(value)
    elseif key == "on_wheel_up" then
      widget:add_button(awful.button({ "Any" }, 4, value))
    elseif key == "on_wheel_down" then
      widget:add_button(awful.button({ "Any" }, 5, value))
    elseif type(key) == "string" and key:find("^on_") then
      -- e.g. "on_mouse_enter" -> "mouse::enter"
      local event_name = key:gsub("^on_", ""):gsub("_", "::", 1)

      if event_name == "click" then
        widget._private.clickable = true
      end

      widget:connect_signal(event_name, value)
    else
      widget[key] = value
    end
  end

  widget.children = children

  -- Keep track of how many times this widget (instance) is shown on the UI to (un)subscribe signals
  widget._private.mount_count = 0

  widget:connect_signal("mount", function()
    if widget._private.mount_count == 0 then
      if next(signals) ~= nil then
        cleanup = bind_signals()
      end
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

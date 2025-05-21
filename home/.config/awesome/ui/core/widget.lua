local gtable = require("gears.table")
local wibox = require("wibox")

local Signal = require("ui.core.signal")
local context = require("ui.core.signal.internal.context")

---@class Widget
local Widget = {}

---@return boolean
local function is_widget(obj)
  return type(obj) == "table" and (obj.widget or obj.layout or rawget(obj, "is_widget"))
end

local function wrap(w, name, fn)
  local old_fn = w[name]
  w[name] = function(_, ...)
    old_fn(w, fn(w, ...))
  end
end

local function set_children(self, new_children)
  if not new_children then
    new_children = {}
  elseif is_widget(new_children) then
    new_children = { new_children }
  end

  if self.attached then
    for _, child in ipairs(new_children) do
      for _, child_old in ipairs(self.children) do
        if child == child_old then
          goto continue
        end
      end

      child:emit_signal("attach")

      ::continue::
    end

    for _, child in ipairs(self.children) do
      for _, child_new in ipairs(new_children) do
        if child == child_new then
          goto continue
        end
      end

      child:emit_signal("detach")

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

  local new_widget = wibox.widget.base.make_widget_declarative({
    widget = args.widget,
  })

  args.widget, args.layout = nil, nil

  gtable.crush(new_widget, Widget, true)

  -- TODO: special handling for add, reset, etc.?
  wrap(new_widget, "set_children", set_children)

  ---@type { signal: Signal, callback: fun(v) }[]
  local signals = {}

  -- Create a scope to automagically clean up signal subscriptions
  local local_scope
  local function attach()
    -- Clean up just in case
    if local_scope then
      local_scope:cleanup()
    end

    -- Reset and push local scope
    local_scope = context.create(nil)
    context.push(local_scope)

    for _, v in ipairs(signals) do
      v.signal:subscribe(v.callback)
    end

    context.pop()
  end

  local children = {}

  -- TODO: reactive children?
  for key, value in pairs(args) do
    if Signal.is_signal(value) then
      ---@cast value Signal
      if type(key) == "string" then
        signals[#signals + 1] = {
          signal = value,
          callback = function(v)
            new_widget[key] = v
          end,
        }
      end
    elseif is_widget(value) then
      children[#children + 1] = Widget.new(value)
    else
      new_widget[key] = value
    end
  end

  new_widget.children = children

  -- Keep track of how many times this widget (instance) is shown on the UI
  local num_attached = 0

  new_widget:connect_signal("attach", function()
    if num_attached == 0 then
      new_widget.attached = true
      attach()

      for _, value in ipairs(new_widget.children) do
        value:emit_signal("attach")
      end
    end

    num_attached = num_attached + 1
  end)

  new_widget:connect_signal("detach", function()
    num_attached = num_attached - 1

    if num_attached == 0 then
      new_widget.attached = false
      local_scope:cleanup()

      for _, value in ipairs(new_widget.children) do
        value:emit_signal("detach")
      end
    end
  end)

  -- TODO: Is this needed?
  local parent_scope = context.current()
  if parent_scope then
    parent_scope:on_cleanup(function()
      if local_scope then
        local_scope:cleanup()
      end
    end)
  end

  return new_widget
end

return Widget

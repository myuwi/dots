local gtable = require("gears.table")
local wibox = require("wibox")

local Signal = require("ui.core.signal")

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

  for _, child in ipairs(self.children) do
    if not rawget(child, "no_implicit_destroy") then
      for _, child_new in ipairs(new_children) do
        if child == child_new then
          goto continue
        end
      end

      child:emit_signal("destroy")
    end

    ::continue::
  end

  return new_children
end

function Widget:on_destroyed(callback)
  self:connect_signal("destroy", function()
    callback()
  end)

  return self
end

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

  local children = {}

  -- TODO: reactive children?
  for key, value in pairs(args) do
    if Signal.is_signal(value) then
      ---@cast value Signal
      if type(key) == "string" then
        local unsub = value:subscribe(function(v)
          new_widget[key] = v
        end)

        new_widget:on_destroyed(unsub)
      end
    elseif is_widget(value) then
      children[#children + 1] = Widget.new(value)
    else
      new_widget[key] = value
    end
  end

  new_widget.children = children

  new_widget:on_destroyed(function()
    for _, value in ipairs(new_widget.children) do
      value:emit_signal("destroy")
    end
  end)

  return new_widget
end

return Widget

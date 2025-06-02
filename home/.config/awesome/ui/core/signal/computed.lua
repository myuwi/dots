local gtable = require("gears.table")
local context = require("ui.core.signal.internal.context")

---@class Computed : Signal, Subscriber
---@field private _value any
---@field private _fn fun()
local Computed = {}

---@private
Computed.__type = "Computed"

---@private
function Computed:_dispose()
  if self._disposed then
    return
  end

  self._disposed = true
  context.clear_scope(self)
end

---@private
function Computed:_notify()
  self._dirty = true
end

---@private
function Computed:_refresh()
  if not self._dirty then
    return
  end

  self._dirty = false

  -- TODO: check if sources changed

  context.clear_scope(self)

  local end_scope = context.start_scope(self)

  self._value = self._fn()

  end_scope()
end

---Peek the signal's current value without subscribing to it
function Computed:peek()
  self:_refresh()
  return self._value
end

---@private
function Computed:get_value()
  context.add_dependency(self)
  self:_refresh()
  return self._value
end

---@private
function Computed:set_value()
  error("Cannot assign value to a computed signal", 3)
end

---Create a new computed signal
---@param fn fun(): any
---@return Computed
local function computed(fn)
  local ret = {
    _fn = fn,
    _dirty = true,
    _disposed = false,
    _subscribers = {},
    _children = {},
    _sources = {},
  }

  gtable.crush(ret, Computed, true)

  context.add_child(ret)

  setmetatable(ret, {
    __index = function(self, key)
      if rawget(self, "get_" .. key) then
        return self["get_" .. key](self)
      else
        return rawget(self, key)
      end
    end,
    __newindex = function(self, key, value)
      if rawget(self, "set_" .. key) then
        self["set_" .. key](self, value)
      else
        rawset(self, key, value)
      end
    end,
  })

  return ret
end

return computed

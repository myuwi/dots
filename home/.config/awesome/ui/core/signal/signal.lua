local gtable = require("gears.table")
local context = require("ui.core.signal.internal.context")

---@class Signal : Source
---@field private _value any
local Signal = {}

---@private
Signal.__type = "Signal"

---@private
---Notify subscribers in breadth-first order
function Signal:_notify()
  local notify_queue = { self }

  while #notify_queue > 0 do
    local node = table.remove(notify_queue, 1)

    for _, sub in ipairs(node._subscribers) do
      sub:_notify()

      if sub._subscribers and #sub._subscribers then
        table.insert(notify_queue, sub)
      end
    end
  end
end

---Peek the signal's current value without subscribing to it
function Signal:peek()
  return self._value
end

---@private
function Signal:get_value()
  context.add_dependency(self)
  return self._value
end

---@private
function Signal:set_value(value)
  if self._value ~= value then
    self._value = value
    local end_batch = context.start_batch()
    self:_notify()
    end_batch()
  end
end

---Create a new signal
---@param initial_value any
---@return Signal
local function signal(initial_value)
  local ret = {
    _value = initial_value,
    _subscribers = {},
  }

  gtable.crush(ret, Signal, true)

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

return signal

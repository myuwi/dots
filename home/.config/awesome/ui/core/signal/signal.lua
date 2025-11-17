local context = require("ui.core.signal._context")

---@class (exact) Signal: Signal.Source
local Signal = {}

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

function Signal:_refresh() end

---Peek the signal's current value without subscribing to it
function Signal:peek()
  return self._value
end

function Signal:get()
  context.add_dependency(self)
  return self._value
end

---@param value any
function Signal:set(value)
  if self._value ~= value then
    self._value = value
    self._version = self._version + 1

    context.with_batch(function()
      self:_notify()
    end)
  end
end

---Create a new signal
---@param initial_value any
---@return Signal
local function signal(initial_value)
  local ret = {
    _value = initial_value,
    _version = 0,
    _subscribers = {},
  }

  setmetatable(ret, { __index = Signal })

  return ret
end

return signal

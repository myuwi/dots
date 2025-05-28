local gtable = require("gears.table")
local context = require("ui.core.signal.internal.context")

---@alias SignalCallback fun(): nil

---@class Signal
---@field value unknown
---@field private _on_subscribe_callbacks SignalCallback[]
---@field private _subscribers Scope[]
---@field private _value any
local Signal = {}

---@private
Signal.__type = "Signal"

---@return boolean # A boolean value indicating whether this signal has active subscribers
function Signal:has_subscribers()
  return #self._subscribers > 0
end

---@param callback SignalCallback Add a new callback to call when a new subscription is made (called before invoking subscribe callback)
function Signal:on_subscribe(callback)
  table.insert(self._on_subscribe_callbacks, callback)
end

---@private
---@param eval_context Scope The eval context to subscribe to
function Signal:_subscribe(eval_context)
  table.insert(self._subscribers, eval_context)

  for _, subscribe_callback in ipairs(self._on_subscribe_callbacks) do
    subscribe_callback()
  end
end

---@private
---@param eval_context Scope The eval context to unsubscribe from
function Signal:_unsubscribe(eval_context)
  for i, fn in ipairs(self._subscribers) do
    if fn == eval_context then
      table.remove(self._subscribers, i)
      break
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

local unpack = unpack or table.unpack
---@private
function Signal:_notify()
  local subs_copy = { unpack(self._subscribers) }
  for _, node in ipairs(subs_copy) do
    node:_notify()
  end
end

---@private
function Signal:set_value(value)
  if self._value ~= value then
    self._value = value
    self:_notify()
  end
end

---Create a new signal
---@param initial_value any
---@return Signal
local function new(initial_value)
  local ret = {
    _value = initial_value,
    _on_subscribe_callbacks = {},
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

---@class SignalModule
---@field private mt table
local M = { mt = {} }

---Checks if the given value is a signal
---@param value any
---@return boolean
function M.is_signal(value)
  return type(value) == "table" and value.__type == Signal.__type
end

function M.mt:__call(...)
  return new(...)
end

---@overload fun(initial_value: any): Signal
local module = setmetatable(M, M.mt)
return module

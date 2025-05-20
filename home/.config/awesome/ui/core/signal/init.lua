local gtable = require("gears.table")

_G.current_signal_observer = nil

---@alias SignalCallbackFn fun(value: unknown): nil

---@class Signal
---@field value unknown
---@field private mt table
---@field private _subs table<SignalCallbackFn, true>
---@field private _value any
---@field private __type "Signal"
local Signal = { mt = {} }

Signal.__type = "Signal"

---@param callback SignalCallbackFn A callback function to invoke when the signal's value changes
---@param immediate? boolean Invoke the callback immediately (default: true)
---@return fun(): nil unsubscribe A function to unsubscribe the callback from the signal
function Signal:subscribe(callback, immediate)
  immediate = immediate == nil and true or immediate

  self._subs[callback] = true

  if immediate then
    callback(self._value)
  end

  return function()
    self:unsubscribe(callback)
  end
end

---@param callback SignalCallbackFn A callback function to unsubscribe from the signal
function Signal:unsubscribe(callback)
  self._subs[callback] = nil
end

function Signal.mt:__index(key)
  if key == "value" then
    if _G.current_signal_observer then
      _G.current_signal_observer.register(self)
    end

    return self._value
  else
    return rawget(self, key)
  end
end

function Signal.mt:__newindex(key, new_value)
  if key == "value" then
    if new_value ~= self._value then
      self._value = new_value

      for cb, _ in pairs(self._subs) do
        cb(self._value)
      end
    end
  else
    rawset(self, key, new_value)
  end
end

---Create a new signal
---@param initial_value any
---@return Signal
local function new(initial_value)
  local ret = { _value = initial_value, _subs = {} }

  gtable.crush(ret, Signal, true)

  return setmetatable(ret, Signal.mt)
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

local gtable = require("gears.table")

---@class Signal
---@field value unknown
---@field subscribe fun(self: Signal, callback: fun(value: unknown)): fun()
---@field private mt table
---@field private _subs (fun(value: unknown))[]
---@field private _value any
---@field private __type "Signal"
local Signal = { mt = {} }

Signal.__type = "Signal"

function Signal:subscribe(cb)
  table.insert(self._subs, cb)

  cb(self._value)

  return function()
    for i, fn in ipairs(self._subs) do
      if fn == cb then
        table.remove(self._subs, i)
        break
      end
    end
  end
end

function Signal.mt:__index(key)
  if key == "value" then
    return self._value
  else
    return rawget(self, key)
  end
end

function Signal.mt:__newindex(key, new_value)
  if key == "value" then
    if new_value ~= self._value then
      self._value = new_value

      for _, cb in ipairs(self._subs) do
        cb(self._value)
      end
    end
  else
    rawset(self, key, new_value)
  end
end

---Create a new signal
---@param initial_value unknown
---@return Signal
local function new(initial_value)
  local ret = { _value = initial_value, _subs = {} }

  gtable.crush(ret, Signal, true)

  return setmetatable(ret, Signal.mt)
end

---@class SignalModule
---@field is_signal fun(obj: any): boolean
---@field private mt table
local M = { mt = {} }

function M.is_signal(v)
  return type(v) == "table" and v.__type == Signal.__type
end

function M.mt:__call(...)
  return new(...)
end

---@overload fun(initial_value: unknown): Signal
local module = setmetatable(M, M.mt)
return module

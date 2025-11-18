local signal = require("lib.signal.signal")

---@class SignalModule
---@field private mt table
local M = { mt = {} }

---Checks if the given value is a signal
---@param value any
---@return boolean
function M.is_signal(value)
  return type(value) == "table" and (value.__type == "Signal" or value.__type == "Computed")
end

function M.mt:__call(...)
  return signal(...)
end

---@overload fun(initial_value: any): Signal
local module = setmetatable(M, M.mt)
return module

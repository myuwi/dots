local signal = require("tide.signal.signal")

---@class SignalModule
---@field private mt table
local M = { mt = {} }

---Check if the given value is a signal
---@param value any
---@return boolean
function M.is_signal(value)
  return type(value) == "table" and (value.__type == "Signal" or value.__type == "Computed")
end

function M.mt:__call(...)
  return signal(...)
end

M.signal = signal
M.computed = require("tide.signal.computed")
M.effect = require("tide.signal.effect")
M.batch = require("tide.signal.batch")
M.track = require("tide.signal.track")
M.untracked = require("tide.signal.untracked")
M.watch = require("tide.signal.watch")

---@overload fun(initial_value: any): Signal
local module = setmetatable(M, M.mt)
return module

local computed = require("ui.core.signal.computed")

---@param signal Signal
---@param fn fun(value: any): any
---@return Signal
local function map(signal, fn)
  return computed(function()
    return fn(signal.value)
  end)
end

return map

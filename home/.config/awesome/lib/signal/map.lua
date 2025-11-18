local computed = require("lib.signal.computed")

---@param signal Signal.Source
---@param fn fun(value: any): any
---@return Computed
local function map(signal, fn)
  return computed(function()
    return fn(signal:get())
  end)
end

return map

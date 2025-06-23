local computed = require("ui.core.signal.computed")

---@param signal Source
---@param fn fun(value: any): any
---@return Computed
local function map(signal, fn)
  return computed(function()
    return fn(signal:get())
  end)
end

return map

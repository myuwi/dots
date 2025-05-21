local signal = require("ui.core.signal")
local effect = require("ui.core.signal.effect")

---@param fn fun(value: any): any
---@return Signal
local function computed(fn)
  local sig = signal(nil)

  effect(function()
    sig.value = fn()
  end)

  return sig
end

return computed

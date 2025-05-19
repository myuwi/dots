local signal = require("ui.core.signal")
local effect = require("ui.core.signal.effect")

local function computed(fn)
  local sig = signal(nil)

  effect(function()
    sig.value = fn()
  end)

  return sig
end

return computed

local signal = require("ui.core.signal")

---@param emitter table
---@param property string
---@return Signal
local function observe(emitter, property)
  local sig = signal(nil)

  emitter:connect_signal("property::" .. property, function()
    sig.value = emitter[property]
  end)

  return sig
end

return observe

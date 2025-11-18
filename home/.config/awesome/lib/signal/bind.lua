local signal = require("lib.signal")

---@param emitter table
---@param property string
---@return Signal
local function bind(emitter, property)
  local sig = signal(emitter[property])

  emitter:connect_signal("property::" .. property, function()
    sig:set(emitter[property])
  end)

  return sig
end

return bind

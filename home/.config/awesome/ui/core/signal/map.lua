local computed = require("ui.core.signal.computed")

local function map(signal, fn)
  return computed(function()
    return fn(signal.value)
  end)
end

return map

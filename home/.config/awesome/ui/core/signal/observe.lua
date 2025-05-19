local signal = require("ui.core.signal")

local function observe(source, property)
  local s = signal(nil)

  source:connect_signal("property::" .. property, function()
    s.value = source[property]
  end)

  return s
end

return observe

local context = require("ui.core.signal._context")

---@param signal Signal.Source
local function track(signal)
  context.add_dependency(signal)
end

return track

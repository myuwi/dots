local context = require("ui.core.signal.internal.context")

---@param fn fun(): any
---@return unknown
local function batch(fn)
  return context.with_batch(fn)
end

return batch

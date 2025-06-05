local context = require("ui.core.signal.internal.context")

---@param fn fun(): any
---@return unknown
local function batch(fn)
  local end_batch = context.start_batch()
  local val = fn()
  end_batch()
  return val
end

return batch

local context = require("tide.signal._context")

---@param fn fun(): any
---@return unknown
local function batch(fn)
  return context.with_batch(fn)
end

return batch

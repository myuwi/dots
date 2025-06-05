local context = require("ui.core.signal.internal.context")

---@param fn fun(): any
---@return unknown
local function untracked(fn)
  return context.with_scope(nil, fn)
end

return untracked

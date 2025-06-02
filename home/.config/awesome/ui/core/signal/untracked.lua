local context = require("ui.core.signal.internal.context")

---@param fn fun(): any
---@return unknown
local function untracked(fn)
  local end_scope = context.start_scope(nil)
  local val = fn()
  end_scope()
  return val
end

return untracked

local context = require("ui.core.signal.internal.context")

---@param fn fun(): fun()?
---@return fun() dispose
local function effect(fn)
  ---@type Scope?
  local local_scope

  local function cleanup()
    if local_scope then
      local_scope:cleanup()
    end
  end

  local function run()
    -- Perform cleanup on the local scope
    cleanup()

    -- Reset and push local scope
    local_scope = context.new(run)
    context.push(local_scope)

    local effect_cleanup = fn()

    if type(effect_cleanup) == "function" then
      local_scope:on_cleanup(effect_cleanup)
    end

    context.pop()
  end

  run()

  -- Register cleanup in parent scope if any
  local parent_scope = context.current()
  if parent_scope then
    parent_scope:on_cleanup(cleanup)
  end

  return cleanup
end

return effect

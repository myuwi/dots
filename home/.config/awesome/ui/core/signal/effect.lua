local context = require("ui.core.signal.internal.context")

local function effect(fn)
  ---@type Scope
  local local_scope

  local function run()
    -- Cleanup the previous local scope
    if local_scope then
      local_scope:cleanup()
    end

    -- Reset and push local scope
    local_scope = context.create(run)
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
    parent_scope:on_cleanup(function()
      local_scope:cleanup()
    end)
  end
end

return effect

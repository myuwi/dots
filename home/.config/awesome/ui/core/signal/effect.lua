local context = require("ui.core.signal.internal.context")

---@param fn fun(): fun()?
---@return fun() dispose
local function effect(fn)
  local run, cleanup = context.with_reactive_scope(function(scope)
    local effect_cleanup = fn()

    if type(effect_cleanup) == "function" then
      scope:on_cleanup(effect_cleanup)
    end
  end)

  run()

  return cleanup
end

return effect

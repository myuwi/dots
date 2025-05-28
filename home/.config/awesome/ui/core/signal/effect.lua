local context = require("ui.core.signal.internal.context")

---@alias EffectFn fun(): fun()?

---@param fn EffectFn
---@return fun() dispose
local function effect(fn)
  local run, cleanup = context.with_reactive_scope(function(scope)
    local effect_cleanup = fn()

    if type(effect_cleanup) == "function" then
      ---@diagnostic disable-next-line: invisible
      scope._cleanup = effect_cleanup
    end
  end)

  run()

  return cleanup
end

return effect

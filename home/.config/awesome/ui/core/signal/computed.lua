local context = require("ui.core.signal.internal.context")
local signal = require("ui.core.signal")

-- TODO: Disable setting value

---@param fn fun(): any
---@return Signal
local function computed(fn)
  local sig = signal(nil)

  local function should_run()
    return sig:has_subscribers()
  end

  local run, _, is_dirty = context.with_reactive_scope(function()
    sig.value = fn()
  end, should_run)

  -- Activate when someone subscribes
  sig:on_subscribe(function()
    if is_dirty() then
      run()
    end
  end)

  return sig
end

return computed

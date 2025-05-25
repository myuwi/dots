local context = require("ui.core.signal.internal.context")
local signal = require("ui.core.signal")

---@param fn fun(): any
---@return Signal
local function computed(fn)
  local sig = signal(nil)

  ---@diagnostic disable-next-line: invisible
  local set_value = sig.set_value

  local function should_run()
    return sig:has_subscribers()
  end

  local run, _, is_dirty = context.with_reactive_scope(function()
    set_value(sig, fn())
  end, should_run)

  -- Activate when someone subscribes
  sig:on_subscribe(function()
    if is_dirty() then
      run()
    end
  end)

  ---@diagnostic disable-next-line: invisible
  sig.set_value = function()
    error("Cannot assign value to a computed signal", 3)
  end

  return sig
end

return computed

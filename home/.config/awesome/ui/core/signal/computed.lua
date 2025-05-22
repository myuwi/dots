local context = require("ui.core.signal.internal.context")
local signal = require("ui.core.signal")

-- TODO: Disable setting value

---@param fn fun(): any
---@return Signal
local function computed(fn)
  local sig = signal(nil)
  local dirty = true

  ---@type Scope?
  local local_scope

  local function cleanup()
    if local_scope then
      local_scope:cleanup()
    end
  end

  local function run()
    if not sig:has_subscribers() then
      dirty = true
      return
    end

    dirty = false

    -- Perform cleanup on the local scope
    cleanup()

    -- Reset and push local scope
    local_scope = context.new(run)
    context.push(local_scope)

    sig.value = fn()

    context.pop()
  end

  -- Activate when someone subscribes
  sig:on_subscribe(function()
    if dirty then
      run()
    end
  end)

  -- Register cleanup in parent scope if any
  local parent_scope = context.current()
  if parent_scope then
    parent_scope:on_cleanup(cleanup)
  end

  return sig
end

return computed

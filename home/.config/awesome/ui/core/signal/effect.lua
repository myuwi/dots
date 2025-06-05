local context = require("ui.core.signal.internal.context")
local batch = require("ui.core.signal.batch")
local untracked = require("ui.core.signal.untracked")

---@alias EffectFn fun(): fun()?

---@class (exact) Effect: Subscriber
---@field private _fn EffectFn
---@field private _cleanup? fun()
---@field private _disposed boolean
local Effect = {}

Effect.__type = "Effect"

function Effect:_dispose()
  if self._disposed then
    return
  end

  self._disposed = true

  context.cleanup_sub(self)

  if self._cleanup then
    batch(function()
      untracked(function()
        self._cleanup()
        self._cleanup = nil
      end)
    end)
  end
end

function Effect:_notify()
  if self._disposed then
    return
  end

  self._dirty = true
  context.queue_effect(self)
end

function Effect:_callback()
  if self._disposed or not self._dirty then
    return
  end

  self._dirty = false

  if not context.should_recompute(self) then
    return
  end

  context.cleanup_sub(self)

  local end_batch = context.start_batch()
  local end_scope = context.start_scope(self)

  self._cleanup = self._fn()

  end_scope()
  end_batch()
end

---@param fn EffectFn
---@return fun() dispose
local function effect(fn)
  local ret = {
    _fn = fn,
    _dirty = true,
    _first_run = true,
    _disposed = false,
    _children = {},
    _sources = {},
  }

  setmetatable(ret, { __index = Effect })

  context.add_child(ret)

  ret:_callback()

  return function()
    ret:_dispose()
  end
end

return effect

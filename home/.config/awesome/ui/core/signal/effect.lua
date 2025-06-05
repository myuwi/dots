local context = require("ui.core.signal._context")

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
    context.with_batch(function()
      context.with_scope(nil, self._cleanup)
    end)
    self._cleanup = nil
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

  context.with_batch(function()
    self._cleanup = context.with_scope(self, self._fn)
  end)
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

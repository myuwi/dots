local context = require("ui.core.signal.internal.context")

---@alias EffectFn fun(): fun()?

---@class Effect : Subscriber
---@field private _fn EffectFn
---@field private _cleanup? fun()
local Effect = {}
Effect.__index = Effect

---@private
Effect.__type = "Effect"

function Effect:_dispose()
  if self._disposed then
    return
  end

  self._disposed = true
  context.clear_scope(self)
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

  -- TODO: check if sources changed

  context.clear_scope(self)

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
    _disposed = false,
    _children = {},
    _sources = {},
  }

  setmetatable(ret, Effect)

  context.add_child(ret)

  ret:_callback()

  return function()
    ret:_dispose()
  end
end

return effect

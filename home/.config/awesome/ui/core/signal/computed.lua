local context = require("ui.core.signal._context")

---@class (exact) Computed: Source, Subscriber
---@field private _fn fun()
local Computed = {}

Computed.__type = "Computed"

--TODO: rename?
function Computed:_dispose()
  context.cleanup_sub(self)
end

function Computed:_notify()
  self._dirty = true
end

function Computed:_refresh()
  if not self._dirty then
    return
  end

  self._dirty = false

  if not context.should_recompute(self) then
    return
  end

  context.cleanup_sub(self)

  local new_value = context.with_scope(self, self._fn)

  if self._value ~= new_value then
    self._value = new_value
    self._version = self._version + 1
  end
end

---Peek the signal's current value without subscribing to it
function Computed:peek()
  self:_refresh()
  return self._value
end

function Computed:get()
  context.add_dependency(self)
  self:_refresh()
  return self._value
end

---Create a new computed signal
---@param fn fun(): any
---@return Computed
local function computed(fn)
  local ret = {
    _fn = fn,
    _version = 0,
    _dirty = true,
    _first_run = true,
    _subscribers = {},
    _children = {},
    _sources = {},
  }

  setmetatable(ret, { __index = Computed })

  context.add_child(ret)

  return ret
end

return computed

---@diagnostic disable: invisible

---@class (exact) Node
---@field protected __type string

---@class (exact) Signal.Source: Node
---@field get fun(self: self): unknown
---@field peek fun(self: self): unknown
---@field protected _value any
---@field protected _version integer
---@field protected _subscribers Signal.Subscriber[]
---@field protected _refresh fun(self: self)

---@class (exact) Signal.Subscriber: Node
---@field protected _dirty boolean
---@field protected _first_run boolean
---@field protected _parent Signal.Subscriber
---@field protected _children Signal.Subscriber[]
---@field protected _sources Signal.Source[]
---@field protected _source_versions table<Signal.Source, integer>
---@field protected _notify fun(self: self)
---@field protected _dispose fun(self: self)

---@type Signal.Subscriber?
local active_scope = nil
local batch_depth = 0

---@type Effect[]
local effect_queue = {}

local M = {}

---@param scope Signal.Subscriber | nil
---@param fn fun(): any
---@return unknown
function M.with_scope(scope, fn)
  local prev = active_scope
  active_scope = scope

  local val = fn()

  active_scope = prev

  return val
end

---@param source Signal.Source
function M.add_dependency(source)
  if not active_scope or active_scope._source_versions[source] then
    return
  end

  active_scope._source_versions[source] = source._version

  table.insert(active_scope._sources, source)
  table.insert(source._subscribers, active_scope)
end

---@param sub Signal.Subscriber
function M.add_child(sub)
  if active_scope then
    table.insert(active_scope._children, sub)
    sub._parent = active_scope
  end
end

---@param sub Signal.Subscriber
function M.cleanup_sub(sub)
  while #sub._sources > 0 do
    ---@type Signal.Source
    local source = table.remove(sub._sources, 1)

    for i, s in ipairs(source._subscribers) do
      if s == sub then
        table.remove(source._subscribers, i)
        break
      end
    end
  end

  sub._source_versions = {}

  while #sub._children > 0 do
    ---@type Signal.Subscriber
    local child_scope = table.remove(sub._children, 1)
    child_scope:_dispose()
  end
end

---@param effect Effect
function M.queue_effect(effect)
  table.insert(effect_queue, effect)
end

---@param fn fun(): any
---@return unknown
function M.with_batch(fn)
  batch_depth = batch_depth + 1

  local val = fn()

  batch_depth = batch_depth - 1

  if batch_depth > 0 then
    return val
  end

  while #effect_queue > 0 do
    ---@type Effect
    local effect = table.remove(effect_queue, 1)
    effect:_callback()
  end

  return val
end

---@param sub Signal.Subscriber
function M.should_recompute(sub)
  if sub._first_run then
    sub._first_run = false
    return true
  end

  for _, source in ipairs(sub._sources) do
    if source._refresh then
      source:_refresh()
    end

    if source._version ~= sub._source_versions[source] then
      return true
    end
  end

  return false
end

return M

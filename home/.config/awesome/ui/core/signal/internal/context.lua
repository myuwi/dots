---@diagnostic disable: invisible
---@class Source
---@field value unknown
---@field private _subscribers Subscriber[]

---@class Subscriber
---@field private _dirty boolean
---@field private _disposed boolean
---@field private _parent Subscriber
---@field private _children Subscriber[]
---@field private _sources Source[]
---@field private _dispose fun()
---@field private _cleanup? fun()

---@type Subscriber?
local active_scope = nil
local batch_depth = 0

---@type Effect[]
local effect_queue = {}

---@class Context
local M = {}

---@param node Subscriber | nil
---@return fun()
---@nodiscard
function M.start_scope(node)
  local prev = active_scope
  active_scope = node

  return function()
    active_scope = prev
  end
end

---@param source Source
function M.add_dependency(source)
  if not active_scope then
    return
  end

  -- TODO: Optimize with a hashmap etc.
  -- Don't allow duplicates sources
  for _, s in ipairs(active_scope._sources) do
    if source == s then
      return
    end
  end

  table.insert(active_scope._sources, source)
  table.insert(source._subscribers, active_scope)
end

---@param scope Subscriber
function M.add_child(scope)
  if active_scope then
    table.insert(active_scope._children, scope)
    scope._parent = active_scope
  end
end

---@param scope Subscriber
function M.clear_scope(scope)
  while #scope._sources > 0 do
    ---@type Signal
    local source = table.remove(scope._sources, 1)

    for i, s in ipairs(source._subscribers) do
      if s == scope then
        table.remove(source._subscribers, i)
        break
      end
    end
  end

  while #scope._children > 0 do
    ---@type Subscriber
    local child_scope = table.remove(scope._children, 1)
    child_scope:_dispose()
  end

  if scope._cleanup then
    scope._cleanup()
    scope._cleanup = nil
  end
end

---@param effect Effect
function M.queue_effect(effect)
  table.insert(effect_queue, effect)
end

function end_batch()
  batch_depth = batch_depth - 1

  if batch_depth > 0 then
    return
  end

  while #effect_queue > 0 do
    ---@type Effect
    local effect = table.remove(effect_queue, 1)
    effect:_callback()
  end
end

function M.start_batch()
  batch_depth = batch_depth + 1
  return end_batch
end

return M

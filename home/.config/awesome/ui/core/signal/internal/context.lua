---@diagnostic disable: invisible

---@class Node
---@field protected __type string

---@class Source: Node
---@field protected _version integer
---@field protected _subscribers Subscriber[]
---@field protected _refresh fun(self: self)

---@class Subscriber: Node
---@field protected _dirty boolean
---@field protected _first_run boolean
---@field protected _parent Subscriber
---@field protected _children Subscriber[]
---@field protected _sources Source[]
---@field protected _source_versions table<Source, integer>
---@field protected _dispose fun(self: self)

---@type Subscriber?
local active_scope = nil
local batch_depth = 0

---@type Effect[]
local effect_queue = {}

---@class Context
local M = {}

---@param sub Subscriber | nil
---@return fun() end_scope
---@nodiscard
function M.start_scope(sub)
  local prev = active_scope
  active_scope = sub

  return function()
    active_scope = prev
  end
end

---@param source Source
function M.add_dependency(source)
  if not active_scope or active_scope._source_versions[source] then
    return
  end

  active_scope._source_versions[source] = source._version

  table.insert(active_scope._sources, source)
  table.insert(source._subscribers, active_scope)
end

---@param sub Subscriber
function M.add_child(sub)
  if active_scope then
    table.insert(active_scope._children, sub)
    sub._parent = active_scope
  end
end

---@param sub Subscriber
function M.cleanup_sub(sub)
  while #sub._sources > 0 do
    ---@type Signal
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
    ---@type Subscriber
    local child_scope = table.remove(sub._children, 1)
    child_scope:_dispose()
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

---@return fun() end_batch
---@nodiscard
function M.start_batch()
  batch_depth = batch_depth + 1
  return end_batch
end

---@param sub Subscriber
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

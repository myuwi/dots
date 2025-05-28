---@class Scope
---@field private _cleanup? fun(): nil
---@field private _notify_callback? fun(): nil
---@field private _sources Signal[]
---@field private _children Scope[]
local Scope = {}
Scope.__index = Scope

---@param signal Signal
function Scope:add_source(signal)
  table.insert(self._sources, signal)

  ---@diagnostic disable-next-line: invisible
  signal:_subscribe(self)
end

---@param child Scope
function Scope:add_child(child)
  table.insert(self._children, child)
end

function Scope:cleanup()
  while #self._sources > 0 do
    ---@type Signal
    local sig = table.remove(self._sources, 1)
    ---@diagnostic disable-next-line: invisible
    sig:_unsubscribe(self)
  end

  while #self._children > 0 do
    ---@type Scope
    local child = table.remove(self._children, 1)
    child:_notify()
  end

  if self._cleanup then
    self._cleanup()
  end
end

function Scope:_notify()
  self._notify_callback()
end

---@type Scope?
local eval_context = nil

---@class Context
local M = {}

---@param notify_callback? fun()
---@return Scope
local function new_scope(notify_callback)
  local ret = {
    _notify_callback = notify_callback,
    _sources = {},
    _children = {},
  }

  return setmetatable(ret, Scope)
end

---@param callback fun(scope: Scope): nil
---@param should_run? fun(): boolean
---@return fun() run
---@return fun() callback
---@return fun() is_dirty
function M.with_reactive_scope(callback, should_run)
  ---@type Scope
  local current_scope
  local dirty = true

  local function cleanup()
    current_scope:cleanup()
  end

  local function run()
    if should_run and not should_run() then
      dirty = true
      return
    end

    dirty = false

    -- Perform cleanup on the local scope
    cleanup()

    local prev = eval_context

    eval_context = current_scope
    current_scope = eval_context

    -- Run callback within the reactive scope
    callback(eval_context)

    eval_context = prev
  end

  local function is_dirty()
    return dirty
  end

  current_scope = new_scope(run)

  -- Register cleanup in parent scope if any
  if eval_context then
    eval_context:add_child(current_scope)
  end

  return run, cleanup, is_dirty
end

---@param signal Signal
function M.add_dependency(signal)
  if not eval_context then
    return
  end

  -- TODO: Optimize
  ---@diagnostic disable-next-line: invisible
  for _, scope in ipairs(signal._subscribers) do
    if scope == eval_context then
      return
    end
  end

  eval_context:add_source(signal)
end

return M

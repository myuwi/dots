local gtable = require("gears.table")

---@class Scope
---@field invalidate? fun(sig: Signal): nil
---@field private _dependencies table<Signal, fun()>
---@field private _cleanups (fun())[]
local Scope = {}

function Scope:on_cleanup(callback)
  table.insert(self._cleanups, callback)
end

function Scope:cleanup()
  for _, cleanup in ipairs(self._cleanups or {}) do
    cleanup()
  end
end

---@type Scope[]
local scope_stack = {}

local M = {}

---@param scope Scope
function M.push(scope)
  table.insert(scope_stack, scope)
end

---@return Scope?
function M.pop()
  return table.remove(scope_stack)
end

---@return Scope?
function M.current()
  return scope_stack[#scope_stack]
end

---@return Scope[]
function M.dump()
  return scope_stack
end

---@param invalidate_callback? fun()
---@return Scope
function M.new(invalidate_callback)
  local ret = {
    invalidate = invalidate_callback,
    _dependencies = {},
    _cleanups = {},
  }

  gtable.crush(ret, Scope, true)

  return ret
end

---@param callback fun(scope: Scope): nil
---@param should_run? fun(): boolean
---@return fun() run
---@return fun() callback
---@return fun() is_dirty
function M.with_reactive_scope(callback, should_run)
  ---@type Scope?
  local current_scope
  local dirty = true

  local function cleanup()
    if current_scope then
      current_scope:cleanup()
    end
  end

  local function run()
    if should_run and not should_run() then
      dirty = true
      return
    end

    dirty = false

    -- Perform cleanup on the local scope
    cleanup()

    -- Reset and push local scope
    current_scope = M.new(run)
    M.push(current_scope)

    -- Run callback within the reactive scope
    callback(current_scope)

    M.pop()
  end

  local function is_dirty()
    return dirty
  end

  -- Register cleanup in parent scope if any
  local parent_scope = M.current()
  if parent_scope then
    parent_scope:on_cleanup(cleanup)
  end

  return run, cleanup, is_dirty
end

return M

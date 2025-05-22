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

return M

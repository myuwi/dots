local gtable = require("gears.table")

---@class Scope
---@field invalidate_callback? fun(sig: Signal): nil
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

---@param invalidate_callback fun()
---@return Scope
function M.create(invalidate_callback)
  local ret = {
    _dependencies = {},
    _cleanups = {},
    invalidate_callback = invalidate_callback,
  }

  gtable.crush(ret, Scope, true)

  return ret
end

return M

local M = {}

---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opts table|nil
M.set_keymap = function(mode, lhs, rhs, opts)
  local _opts = { noremap = true, silent = true }
  if opts then
    _opts = vim.tbl_deep_extend("force", _opts, opts)
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

M.Set = function(list)
  local set = {}
  for _, l in ipairs(list) do
    set[l] = true
  end
  return set
end

return M

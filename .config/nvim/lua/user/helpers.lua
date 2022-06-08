local M = {}

M.Set = function(list)
  local set = {}
  for _, l in ipairs(list) do
    set[l] = true
  end
  return set
end

return M

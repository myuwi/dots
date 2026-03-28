local M = {}

--- @param tbl table Table to map
--- @param callback fun(element: any, i: number, tbl: table): any A mapping function
--- @return table table A mapped table
function M.map(tbl, callback)
  local t = {}
  for i, element in ipairs(tbl) do
    t[#t + 1] = callback(element, i, tbl)
  end
  return t
end

return M

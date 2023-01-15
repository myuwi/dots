local _M = {}

--- Creates a shallow copy of a portion of a given table,
--- filtered down to just the elements from the given table
--- that pass the test implemented by the provided function.
---
--- ```
--- local visible_clients = filter(client.get(), function filter_function(c)
---   return c.first_tag.selected
--- end)
--- ```
---
--- @param tbl table Table to filter
--- @param callback fun(element: any, i: number, tbl: table): boolean A test function
--- @return table table A filtered table
_M.filter = function(tbl, callback)
  local t = {}
  for i, element in ipairs(tbl) do
    if callback(element, i, tbl) then
      table.insert(t, element)
    end
  end
  return t
end

_M.map = function(tbl, callback)
  local t = {}
  for i, element in ipairs(tbl) do
    table.insert(t, callback(element, i, tbl))
  end
  return t
end

_M.reduce = function(tbl, callback, initial)
  local acc = initial or table.remove(tbl, 1)
  for i, element in ipairs(tbl) do
    acc = callback(acc, element, i, tbl)
  end
  return acc
end

return _M

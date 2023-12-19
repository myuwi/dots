local _M = {}

_M.includes = function(tbl, value)
  for i, _ in ipairs(tbl) do
    if tbl[i] == value then
      return true
    end
  end
  return false
end

--- Creates a shallow copy of a portion of a given table
--- filtered down to just the elements from the given table
--- that pass the test implemented by the provided function.
---
--- @param tbl table Table to filter
--- @param callback fun(element: any, i: number, tbl: table): boolean A test function
--- @return table table A filtered table
_M.filter = function(tbl, callback)
  local t = {}
  for i, element in ipairs(tbl) do
    if callback(element, i, tbl) then
      t[#t + 1] = element
    end
  end
  return t
end

_M.map = function(tbl, callback)
  local t = {}
  for i, element in ipairs(tbl) do
    t[#t + 1] = callback(element, i, tbl)
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

--- @param tbl table Table to stringify
_M.stringify = function(tbl)
  if type(tbl) ~= "table" then
    return tostring(tbl)
  end

  local s = "{ "
  for k, v in pairs(tbl) do
    if type(k) ~= "number" then
      k = '"' .. k .. '"'
    end
    s = s .. "[" .. k .. "] = " .. _M.stringify(v) .. ", "
  end
  return s .. "}"
end

return _M

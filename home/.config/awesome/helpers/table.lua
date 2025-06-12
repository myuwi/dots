local M = {}

function M.includes(tbl, value)
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
function M.filter(tbl, callback)
  local t = {}
  for i, element in ipairs(tbl) do
    if callback(element, i, tbl) then
      t[#t + 1] = element
    end
  end
  return t
end

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

function M.reduce(tbl, callback, initial)
  local acc = initial or table.remove(tbl, 1)
  for i, element in ipairs(tbl) do
    acc = callback(acc, element, i, tbl)
  end
  return acc
end

--- @param tbl table Table to map
--- @param predicate fun(element: any, i: number, tbl: table): any A predicate function
--- @return boolean A mapped table
function M.any(tbl, predicate)
  for i, element in ipairs(tbl) do
    if predicate(element, i, tbl) then
      return true
    end
  end
  return false
end

local function stringify_impl(tbl, depth, current_depth)
  if type(tbl) ~= "table" then
    return tostring(tbl)
  end

  if next(tbl) == nil then
    return "{}"
  end

  if current_depth >= depth then
    return "{ ... }"
  end

  local s = "{ "
  for k, v in pairs(tbl) do
    local key = type(k) == "number" and k or '"' .. tostring(k) .. '"'
    local value

    if type(v) == "string" then
      value = '"' .. v .. '"'
    else
      value = stringify_impl(v, depth, current_depth + 1)
    end

    s = s .. "[" .. key .. "] = " .. value .. ", "
  end
  return s .. "}"
end

--- @param tbl any Table to stringify
--- @param depth? integer Maximum recursion depth (default: 3)
function M.stringify(tbl, depth)
  return stringify_impl(tbl, depth or 3, 0)
end

function M.clone(tbl)
  local t = {}

  for key, value in pairs(tbl) do
    t[key] = value
  end

  return t
end

function M.merge(...)
  local t = {}

  for _, source in ipairs({ ... }) do
    for key, value in pairs(source) do
      t[key] = value
    end
  end

  return t
end

function M.pick(tbl, keys)
  local t = {}

  for _, key in ipairs(keys) do
    t[key] = tbl[key]
  end

  return t
end

function M.take(tbl, keys)
  local t = {}

  for _, key in ipairs(keys) do
    t[key], tbl[key] = tbl[key], nil
  end

  return t
end

return M

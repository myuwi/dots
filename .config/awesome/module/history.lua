-- Custom history implementation that became kinda useless when I realized
-- that `client.get(nil, true)` returns clients in their z-order...

local helpers = require("helpers")

local _M = {}

local focus_history = setmetatable({}, { __mode = "v" })
local history_index = 1

local function compare(a, b)
  return a[1] > b[1]
end

_M.get = function()
  local history_entries = {}
  for client, h_index in pairs(focus_history) do
    history_entries[#history_entries + 1] = { h_index, client }
  end

  if #history_entries > 0 then
    table.sort(history_entries, compare)
  end

  local result = helpers.table.map(history_entries, function(entry)
    return entry[2]
  end)

  return result
end

local function history_send_to_back(c)
  local min_index = history_index

  for _, h_index in pairs(focus_history) do
    if h_index < min_index then
      min_index = h_index
    end
  end

  focus_history[c] = min_index - 1
end

local function history_add(c)
  focus_history[c] = history_index
  history_index = history_index + 1
end

local function history_remove(c)
  focus_history[c] = nil
end

client.connect_signal("manage", history_add)

client.connect_signal("focus", history_add)

client.connect_signal("unmanage", history_remove)

client.connect_signal("property::minimized", history_send_to_back)

return _M

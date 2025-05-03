local menubar_utils = require("menubar.utils")

local _M = {}

--- @param client_name string
_M.find_icon = function(client_name)
  local icon = menubar_utils.lookup_icon(client_name)

  -- Try to "correct" the class to find the icon
  if not icon and client_name:find("[%s%u]") then
    -- Make lowercase and replace spaces with "-"
    local name = string.lower(client_name):gsub("%s+", "-")
    icon = menubar_utils.lookup_icon(name)
  end

  return icon
end

return _M

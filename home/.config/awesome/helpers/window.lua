local awful = require("awful")

local M = {}

--- @param target any
function M.set_prop(target, prop_name, value)
  local prop_type = type(value) == "number" and "32c" or "8s"

  awful.spawn(
    "xprop -id "
      .. target.window
      .. " -f "
      .. prop_name
      .. " "
      .. prop_type
      .. " -set "
      .. prop_name
      .. " "
      .. tostring(value),
    false
  )
end

return M

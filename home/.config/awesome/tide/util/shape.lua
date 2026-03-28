local gears = require("gears")

local M = {}

--- Rounded rectangle with a set border radius.
--- @param radius number Border radius
function M.rounded_rect(radius)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end
end

return M

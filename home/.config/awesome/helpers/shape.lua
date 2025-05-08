local gears = require("gears")

local M = {}

--- Rounded rectangle with a set border radius.
--- @param radius number Border radius
function M.rounded_rect(radius)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end
end

--- Partially Rounded rectangle with a set border radius.
--- @param radius number Border radius
--- @param tl boolean If the top left corner is rounded
--- @param tr boolean If the top right corner is rounded
--- @param br boolean If the bottom right corner is rounded
--- @param bl boolean If the bottom left corner is rounded
function M.partially_rounded_rect(radius, tl, tr, br, bl)
  return function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
  end
end

return M

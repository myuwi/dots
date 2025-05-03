local gears = require("gears")

local _M = {}

--- Rounded rectangle with a set border radius.
--- @param radius number Border radius
_M.rounded_rect = function(radius)
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
_M.partially_rounded_rect = function(radius, tl, tr, br, bl)
  return function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
  end
end

return _M

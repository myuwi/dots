local M = {}

local minmax = function(n, min, max)
  return math.max(math.min(n, max), min)
end

--- Convert Hex to Decimal
--- @param hex string a hexadecimal value
local hex_to_decimal = function(hex)
  return tonumber(hex, 16)
end

--- Convert Decimal to Hex
--- @param decimal number a hexadecimal value
local decimal_to_hex = function(decimal)
  return string.format("%02x", decimal)
end

function M.rgb_to_hex(color)
  local r = minmax(color.r or color[1], 0, 255)
  local g = minmax(color.g or color[2], 0, 255)
  local b = minmax(color.b or color[3], 0, 255)

  return "#" .. string.format("%02x%02x%02x", math.floor(r), math.floor(g), math.floor(b))
end

function M.hex_to_rgb(color)
  color = color:gsub("#", "")

  return {
    r = hex_to_decimal(color:sub(1, 2)),
    g = hex_to_decimal(color:sub(3, 4)),
    b = hex_to_decimal(color:sub(5, 6)),
  }
end

function M.gradient(color1, color2, phase)
  local rgb1 = M.hex_to_rgb(color1)
  local rgb2 = M.hex_to_rgb(color2)

  local r = math.ceil(rgb1.r * (1 - phase) + rgb2.r * phase)
  local g = math.ceil(rgb1.g * (1 - phase) + rgb2.g * phase)
  local b = math.ceil(rgb1.b * (1 - phase) + rgb2.b * phase)

  return M.rgb_to_hex({ r, g, b })
end

-- Lightens a given hex color by the specified amount
function M.lighten(color, amount)
  local rgb = M.hex_to_rgb(color)
  local r = rgb.r
  local g = rgb.g
  local b = rgb.b

  r = r + math.floor(2.55 * amount)
  g = g + math.floor(2.55 * amount)
  b = b + math.floor(2.55 * amount)
  r = r > 255 and 255 or r
  g = g > 255 and 255 or g
  b = b > 255 and 255 or b

  return M.rgb_to_hex({ r, g, b })
end

-- Darkens a given hex color by the specified amount
function M.darken(color, amount)
  local rgb = M.hex_to_rgb(color)
  local r = rgb.r
  local g = rgb.g
  local b = rgb.b

  r = math.max(0, r - math.floor(r * (amount / 100)))
  g = math.max(0, g - math.floor(g * (amount / 100)))
  b = math.max(0, b - math.floor(b * (amount / 100)))
  return M.rgb_to_hex({ r, g, b })
end

return M

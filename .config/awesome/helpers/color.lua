local _color = {}

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

_color.rgb_to_hex = function(color)
  local r = minmax(color.r or color[1], 0, 255)
  local g = minmax(color.g or color[2], 0, 255)
  local b = minmax(color.b or color[3], 0, 255)

  return "#" .. string.format("%02x%02x%02x", math.floor(r), math.floor(g), math.floor(b))
end

_color.hex_to_rgb = function(color)
  color = color:gsub("#", "")

  return {
    r = hex_to_decimal(color:sub(1, 2)),
    g = hex_to_decimal(color:sub(3, 4)),
    b = hex_to_decimal(color:sub(5, 6)),
  }
end

_color.gradient = function(color1, color2, phase)
  local rgb1 = _color.hex_to_rgb(color1)
  local rgb2 = _color.hex_to_rgb(color2)

  local r = math.ceil(rgb1.r * (1 - phase) + rgb2.r * phase)
  local g = math.ceil(rgb1.g * (1 - phase) + rgb2.g * phase)
  local b = math.ceil(rgb1.b * (1 - phase) + rgb2.b * phase)

  return _color.rgb_to_hex({ r, g, b })
end

return _color

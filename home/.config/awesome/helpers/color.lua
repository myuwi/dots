local gmath = require("gears.math")

local M = {}

---Clamp a value to the rgb color range (0-255)
---@param x number a value
local function clamp(x)
  return gmath.round(math.max(0, math.min(255, x)))
end

---Convert Hex to Decimal
---@param value string A hexadecimal value
---@return integer value Value as decimal
local function hex_to_decimal(value)
  return tonumber(value, 16)
end

---Convert Decimal to Hex
---@param value integer A decimal value
---@return string value Value as hexacedimal
local function decimal_to_hex(value)
  return string.format("%02x", value)
end

---@param color table
---@return string
local function rgba_to_hex(color)
  local r = clamp(color.r)
  local g = clamp(color.g)
  local b = clamp(color.b)
  local a = color.a and clamp(color.a) or 255

  return "#" .. decimal_to_hex(r) .. decimal_to_hex(g) .. decimal_to_hex(b) .. (a < 255 and decimal_to_hex(a) or "")
end

---@param color string
---@return table
local function hex_to_rgba(color)
  color = color:gsub("#", "")

  local len = color:len()

  return {
    r = hex_to_decimal(color:sub(1, 2)),
    g = hex_to_decimal(color:sub(3, 4)),
    b = hex_to_decimal(color:sub(5, 6)),
    a = len == 8 and hex_to_decimal(color:sub(7, 8)) or 255,
  }
end

---Blend two colors together at a phase
---@param color1 string A color in hexadecimal
---@param color2 string A color in hexadecimal
---@param phase number A number between 0-1
---@return string color The resulting color in hexadecimal
function M.blend(color1, color2, phase)
  local rgba1 = hex_to_rgba(color1)
  local rgba2 = hex_to_rgba(color2)

  local function blend_channel(c1, c2)
    return math.ceil(c1 * (1 - phase) + c2 * phase)
  end

  return rgba_to_hex({
    r = blend_channel(rgba1.r, rgba2.r),
    g = blend_channel(rgba1.g, rgba2.g),
    b = blend_channel(rgba1.b, rgba2.b),
    a = blend_channel(rgba1.a, rgba2.a),
  })
end

---Lightens the given hex color by the specified amount
---@param color string A color in hexadecimal
---@param amount number A number between 0-1
---@return string color The resulting color in hexadecimal
function M.lighten(color, amount)
  local rgba = hex_to_rgba(color)

  local function lighten(c)
    return clamp(c + (255 - c) * amount)
  end

  return rgba_to_hex({
    r = lighten(rgba.r),
    g = lighten(rgba.g),
    b = lighten(rgba.b),
    a = rgba.a,
  })
end

---Darkens the given hex color by the specified amount
---@param color string A color in hexadecimal
---@param amount number A number between 0-1
---@return string color The resulting color in hexadecimal
function M.darken(color, amount)
  local rgba = hex_to_rgba(color)

  local function darken(c)
    return clamp(c * (1 - amount))
  end

  return rgba_to_hex({
    r = darken(rgba.r),
    g = darken(rgba.g),
    b = darken(rgba.b),
    a = rgba.a,
  })
end

---Apply an opacity to a color
---@param color string A color in hexadecimal
---@param opacity number A number between 0-1
---@return string color The resulting color in #RRGGBBAA
function M.opacity(color, opacity)
  return color .. decimal_to_hex(clamp(math.floor((opacity * 255) + 0.5)))
end

return M

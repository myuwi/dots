local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local signal = require("ui.core.signal")
local computed = require("ui.core.signal.computed")

local Image = require("ui.widgets").Image

---@class (exact) IconArgs
---@field color? string | Source
---@field size? integer | Source
---@field [1] string | Source

---@param args IconArgs
local function Icon(args)
  local image = computed(function()
    ---@diagnostic disable-next-line: param-type-mismatch
    local name = signal.is_signal(args[1]) and args[1]:get() or args[1]
    return beautiful.icon_path .. name .. ".svg"
  end)

  local stylesheet = computed(function()
    ---@diagnostic disable-next-line: param-type-mismatch
    local color = signal.is_signal(args.color) and args.color:get() or args.color
    return "* { color:" .. (color or beautiful.fg_normal) .. " }"
  end)

  return Image {
    image = image,
    stylesheet = stylesheet,
    scaling_quality = "best",
    forced_width = args.size or dpi(14),
    forced_height = args.size or dpi(14),
  }
end

return Icon

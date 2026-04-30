local awful = require("awful")
local beautiful = require("beautiful")
local gcolor = require("gears.color")
local gsurface = require("gears.surface")
local hcolor = require("helpers.color")

local lgi = require("lgi")
local cairo = lgi.cairo

local Window = require("tide.core.window")
local Stack = require("tide.widget").Stack
local Image = require("tide.widget").Image
local Container = require("tide.widget").Container

tag.connect_signal("request::default_layouts", function()
  awful.layout.append_default_layouts({
    -- TODO: Let client only occupy master, even if stack is empty
    awful.layout.suit.tile,
    awful.layout.suit.max,
  })
end)

screen.connect_signal("request::desktop_decoration", function(s)
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
end)

local function add_grain(surface, intensity)
  local tile = 64
  local noise = cairo.ImageSurface(cairo.Format.ARGB32, tile, tile)
  local ncr = cairo.Context(noise)

  for y = 0, tile - 1 do
    for x = 0, tile - 1 do
      local v = math.random()
      ncr:set_source_rgba(v, v, v, 1)
      ncr:rectangle(x, y, 1, 1)
      ncr:fill()
    end
  end

  local pat = cairo.Pattern.create_for_surface(noise)
  pat:set_extend(cairo.Extend.REPEAT)

  local cr = cairo.Context(surface)
  cr:set_operator(cairo.Operator.OVERLAY)
  cr:set_source(pat)
  cr:paint_with_alpha(intensity)
end

screen.connect_signal("request::wallpaper", function(s)
  if beautiful.wallpaper then
    local geo = s.geometry

    local cropped = gsurface.crop_surface({
      ratio = geo.width / geo.height,
      surface = gsurface.load_uncached(beautiful.wallpaper),
    })

    add_grain(cropped, 0.15)

    Window {
      window = awful.wallpaper,
      screen = s,
      Stack {
        Image { image = cropped },
        Container {
          bg = gcolor {
            type = "linear",
            from = { 0, 0 },
            to = { 0, 96 },
            stops = {
              { 0, hcolor.opacity(beautiful.colors.black, 0.6) },
              { 0.3, hcolor.opacity(beautiful.colors.black, 0.5) },
              { 1, hcolor.opacity(beautiful.colors.black, 0) },
            },
          },
        },
      },
    }
  end
end)

local cairo = require("lgi").cairo
local gcolor = require("gears.color")

local shadow = {}

local function gaussian_1d(radius)
  local sigma = radius / 2
  local samples, total = {}, 0
  for d = -radius, radius do
    local w = math.exp(-(d * d) / (2 * sigma * sigma))
    samples[#samples + 1] = { d, w }
    total = total + w
  end
  for _, s in ipairs(samples) do
    s[2] = s[2] / total
  end
  return samples
end

---Draw a shadow on `cr` for whatever silhouette `render(cr)` produces.
---Only the silhouette's alpha matters; its color is overridden by `opts.color`.
function shadow.draw_shadow(cr, width, height, opts, render)
  local ox, oy = opts.x or 0, opts.y or 0
  local radius = math.ceil(opts.blur or 0)
  local color = gcolor(opts.color or "#000000")

  local sw, sh = width + 2 * radius, height + 2 * radius
  local source = cairo.ImageSurface(cairo.Format.ARGB32, sw, sh)
  do
    local sc = cairo.Context(source)
    sc:translate(radius, radius)
    render(sc)
  end

  local mask = source
  if radius > 0 then
    local samples = gaussian_1d(radius)

    local hp = cairo.ImageSurface(cairo.Format.ARGB32, sw, sh)
    local hc = cairo.Context(hp)
    hc.operator = cairo.Operator.ADD
    for _, sm in ipairs(samples) do
      hc:set_source_surface(source, sm[1], 0)
      hc:paint_with_alpha(sm[2])
    end

    local vp = cairo.ImageSurface(cairo.Format.ARGB32, sw, sh)
    local vc = cairo.Context(vp)
    vc.operator = cairo.Operator.ADD
    for _, sm in ipairs(samples) do
      vc:set_source_surface(hp, 0, sm[1])
      vc:paint_with_alpha(sm[2])
    end
    mask = vp
  end

  cr:save()
  cr:translate(ox - radius, oy - radius)
  cr:set_source(color)
  cr:mask_surface(mask, 0, 0)
  cr:restore()
end

return shadow

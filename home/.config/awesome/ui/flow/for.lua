local computed = require("lib.signal.computed")

local function For(opts)
  return computed(function()
    local items = opts.each:get()
    local render = opts[1] or opts.render

    local widgets = {}
    for i, item in ipairs(items) do
      widgets[i] = render(item, i)
    end
    return widgets
  end)
end

return For

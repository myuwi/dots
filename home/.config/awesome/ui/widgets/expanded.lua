local flexible = require("ui.widgets.flexible")

local expanded = { mt = {} }

local function new(widget, flex)
  local ret = flexible(widget, flex, true)
  ret.widget_name = "Expanded"

  return ret
end

function expanded.mt:__call(...)
  return new(...)
end

return setmetatable(expanded, expanded.mt)

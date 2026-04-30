pcall(require, "luarocks.loader")

modkey = "Mod4"

function debug_print(...)
  local htable = require("helpers.table")
  local n = select("#", ...)

  local parts = {}
  for i = 1, n do
    local v = select(i, ...)
    parts[#parts + 1] = htable.stringify(v)
  end

  local message = table.concat(parts, " ")
  print(message)
end

awesome.register_xproperty("_ANIMATE", "string")
awesome.register_xproperty("_SHADOW_DISABLE", "boolean")

require("errors")
require("theme")
require("core")
require("ui")

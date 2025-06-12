local gtimer = require("gears.timer")

local M = {}

local unpack = unpack or table.unpack
function M.throttle(fn)
  local queued = false

  return function(...)
    local args = { ... }

    if not queued then
      gtimer.delayed_call(function()
        fn(unpack(args))
        queued = false
      end)
      queued = true
    end
  end
end

return M

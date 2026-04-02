local gtimer = require("gears.timer")

local focus_change = {}

--- Create a focus change handler for a window
--- @param window table The window to watch for focus changes
--- @return table Handler with attach and detach methods
function focus_change.create_handler(window)
  ---@type fun() | nil
  local cb = nil

  local function focus_handler()
    -- Only trigger if window is still visible
    if window.visible and cb then
      cb()
    end
  end

  ---@param callback fun()
  local function attach(callback)
    gtimer.run_delayed_calls_now()

    cb = callback

    client.connect_signal("focus", focus_handler)
    tag.connect_signal("property::selected", focus_handler)
  end

  local function detach()
    gtimer.delayed_call(function()
      cb = nil

      client.disconnect_signal("focus", focus_handler)
      tag.disconnect_signal("property::selected", focus_handler)
    end)
  end

  return {
    attach = attach,
    detach = detach,
  }
end

return focus_change

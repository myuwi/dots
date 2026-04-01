local awful = require("awful")
local gtimer = require("gears.timer")
local wibox = require("wibox")

local htable = require("helpers.table")
local hmouse = require("helpers.mouse")

local click_away = {}

--- Create a click-away handler for a window
--- @param window table The window to watch for clicks outside of
--- @param focus_events boolean? Whether to also trigger on focus changes
--- @return table Handler with attach and detach methods
function click_away.create_handler(window, focus_events)
  ---@type fun(target: any) | nil
  local cb = nil

  -- TODO: Ignore notifications, backdrop, etc.?
  local function cb_handler(target, _, _, button)
    if target == window then
      return
    end

    -- Ignore scroll events
    if type(button) == "number" and button > 3 then
      return
    end

    if cb then
      cb(target)
    end
  end

  local root_binds = htable.map({ 1, 2, 3 }, function(n)
    return awful.button({ "Any" }, n, cb_handler)
  end)

  ---@param callback fun(target: any)
  local function attach(callback)
    gtimer.run_delayed_calls_now()

    cb = callback

    awful.mouse.append_global_mousebindings(root_binds)
    client.connect_signal("button::press", cb_handler)
    wibox.connect_signal("button::press", cb_handler)

    if focus_events then
      client.connect_signal("focus", cb_handler)
      tag.connect_signal("property::selected", cb_handler)
    end
  end

  local function detach()
    -- Disconnecting the handler immediately may cause another handler for the same target to be skipped due to
    -- the handlers being stored in a list that is iterated over, causing handler indices to shift mid execution,
    -- so wait for all handlers to be fired before disconnecting any of them
    gtimer.delayed_call(function()
      cb = nil

      hmouse.remove_global_mousebindings(root_binds)
      client.disconnect_signal("button::press", cb_handler)
      wibox.disconnect_signal("button::press", cb_handler)

      if focus_events then
        client.disconnect_signal("focus", cb_handler)
        tag.disconnect_signal("property::selected", cb_handler)
      end
    end)
  end

  return {
    attach = attach,
    detach = detach,
  }
end

return click_away

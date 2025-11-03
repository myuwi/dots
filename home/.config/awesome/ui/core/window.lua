local gtimer = require("gears.timer")
local wibox = require("wibox")
local Widget = require("ui.core.widget")
local util = require("ui.core.util")

local Window = {}

local function set_visible(w, visible)
  if w.visible == visible then
    return
  end

  if w.widget and w.widget.emit_signal then
    if visible then
      w.widget:emit_signal("mount")
    else
      w.widget:emit_signal("unmount")
    end
  end

  if visible then
    -- Force popup to update its geometry before it is made visible
    -- See: https://github.com/awesomeWM/awesome/blob/8b1f8958b46b3e75618bc822d512bb4d449a89aa/lib/awful/popup.lua#L115
    if w._apply_size_now then
      w:_apply_size_now()
    end

    -- Delay show until geometry and widget contents have updated
    gtimer.delayed_call(function()
      w.drawin.visible = true
    end)
  else
    w.drawin.visible = false
  end
end

-- TODO: on_click_outside
-- TODO: better support widget_template?
function Window.new(args)
  local window_constructor = args.window or wibox
  args.window = nil

  args.widget = args.widget and Widget.new(args.widget) or args[1] and Widget.new(args[1])
  args[1] = nil

  if args.widget and args.visible ~= false then
    args.widget:emit_signal("mount")
  end

  local window = window_constructor(args)

  -- TODO: also emit mount/unmount when the widget is reassigned
  util.wrap(window, "set_visible", set_visible)

  return window
end

return Window.new

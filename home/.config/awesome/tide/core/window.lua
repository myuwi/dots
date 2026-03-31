local gtimer = require("gears.timer")
local wibox = require("wibox")
local Widget = require("tide.core.widget")
local util = require("tide.core.util")

local function set_visible(win, visible)
  if win.visible == visible then
    return
  end

  local tide_widget = win._private.tide_widget
  if tide_widget then
    if visible then
      tide_widget:emit_signal("mount")
    else
      tide_widget:emit_signal("unmount")
    end
  end

  if visible then
    -- Force popup to update its geometry before it is made visible
    -- See: https://github.com/awesomeWM/awesome/blob/8b1f8958b46b3e75618bc822d512bb4d449a89aa/lib/awful/popup.lua#L115
    if win._apply_size_now then
      win:_apply_size_now()
    end

    -- Delay show until geometry and widget contents have updated
    gtimer.delayed_call(function()
      win.drawin.visible = true
    end)
  else
    win.drawin.visible = false
  end
end

-- TODO: on_click_outside
local function Window(args)
  args = args or {}

  local window_constructor = args.window or wibox
  args.window = nil

  -- Extract Tide widget content
  local tide_widget = args.widget or args[1]
  args.widget = tide_widget and Widget(tide_widget)
  args[1] = nil

  local window = window_constructor(args)

  -- Store reference for set_visible wrapper (args.widget is the converted Tide widget, or nil if none was provided)
  window._private.tide_widget = args.widget

  if tide_widget and args.visible ~= false then
    args.widget:emit_signal("mount")
  end

  -- TODO: also emit mount/unmount when the widget is reassigned
  util.wrap(window, "set_visible", set_visible)

  return window
end

return Window

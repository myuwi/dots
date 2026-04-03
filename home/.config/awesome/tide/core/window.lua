local gtimer = require("gears.timer")
local wibox = require("wibox")
local Widget = require("tide.core.widget")
local util = require("tide.util")

local backdrop = require("tide.core.backdrop")
local click_away = require("tide.core.click_away")
local focus_change = require("tide.core.focus_change")

local function set_visible(win, visible)
  if win.visible == visible then
    return
  end

  if win._private.click_away_handler then
    if visible then
      win._private.click_away_handler.attach(function(target)
        if win._private.on_click_outside then
          win._private.on_click_outside(win, target)
        end
      end)
    else
      win._private.click_away_handler.detach()
    end
  end

  if win._private.focus_change_handler then
    if visible then
      win._private.focus_change_handler.attach(function()
        if win._private.on_blur then
          win._private.on_blur(win)
        end
      end)
    else
      win._private.focus_change_handler.detach()
    end
  end

  if win._private.use_backdrop then
    if visible then
      backdrop.attach()
    else
      backdrop.detach()
    end
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

local function Window(args)
  args = args or {}

  local window_constructor = args.window or wibox
  args.window = nil

  local use_backdrop = args.backdrop
  local on_click_outside = args.on_click_outside
  local on_blur = args.on_blur
  args.backdrop = nil
  args.on_click_outside = nil
  args.on_blur = nil

  local tide_widget = args.widget or args[1]
  args.widget = tide_widget and Widget(tide_widget)
  args[1] = nil

  local window = window_constructor(args)

  window._private.tide_widget = args.widget
  window._private.use_backdrop = use_backdrop
  window._private.on_click_outside = on_click_outside
  window._private.on_blur = on_blur

  -- Create click-away handler if needed
  if on_click_outside then
    window._private.click_away_handler = click_away.create_handler(window, false)
  end

  -- Create focus change handler if needed
  if on_blur then
    window._private.focus_change_handler = focus_change.create_handler(window)
  end

  -- Show backdrop and attach handlers if window starts visible
  if args.visible then
    if use_backdrop then
      backdrop.attach()
    end
    if window._private.click_away_handler then
      window._private.click_away_handler.attach(function(target)
        on_click_outside(window, target)
      end)
    end
    if window._private.focus_change_handler then
      window._private.focus_change_handler.attach(function()
        on_blur(window)
      end)
    end
  end

  if tide_widget and args.visible ~= false then
    args.widget:emit_signal("mount")
  end

  -- TODO: also emit mount/unmount when the widget is reassigned
  util.wrap(window, "set_visible", set_visible)

  return window
end

return Window

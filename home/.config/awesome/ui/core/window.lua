local widget = require("ui.core.widget")
local util = require("ui.core.util")

---@class Window
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

  -- Hacky way to avoid popup not updating its position for one frame after it is made visible
  -- Possibly due to this https://github.com/awesomeWM/awesome/blob/8b1f8958b46b3e75618bc822d512bb4d449a89aa/lib/awful/popup.lua#L115
  -- TODO: Is this okay to use?
  if w._apply_size_now then
    w:_apply_size_now()
  end

  w.drawin.visible = visible
end

function Window.new(args)
  local window_constructor = args.window
  args.window = nil

  args.widget = widget.new(args.widget)

  if args.widget and args.visible ~= false then
    args.widget:emit_signal("mount")
  end

  local window = window_constructor(args)

  -- TODO: also emit mount/unmount when the widget is reassigned
  util.wrap(window, "set_visible", set_visible)

  return window
end

return Window

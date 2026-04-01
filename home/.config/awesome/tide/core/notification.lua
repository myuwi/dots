local naughty = require("naughty")
local util = require("tide.core.util")

local Widget = require("tide.core.widget")

local function set_visible(box, visible)
  if box.visible == visible then
    return
  end

  local tide_widget = box._private.tide_widget
  if tide_widget then
    if visible then
      tide_widget:emit_signal("mount")
    else
      tide_widget:emit_signal("unmount")
    end
  end

  box.drawin.visible = visible
end

local function Notification(args)
  args = args or {}

  local tide_widget = args[1] or args.widget
  args[1], args.widget = nil, nil

  if tide_widget then
    tide_widget = Widget(tide_widget)
    args.widget_template = tide_widget
  end

  local box = naughty.layout.box(args)

  box._private.tide_widget = tide_widget

  if tide_widget and box.visible then
    tide_widget:emit_signal("mount")
  end

  util.wrap(box, "set_visible", set_visible)

  -- Handle notification destruction
  if args.notification then
    args.notification:connect_signal("destroyed", function()
      if tide_widget then
        tide_widget:emit_signal("unmount")
      end
    end)
  end

  return box
end

return Notification

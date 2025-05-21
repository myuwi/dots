local widget = require("ui.core.widget")

---@class Window
local Window = {}

function Window.new(args)
  local window_type = args.window
  args.window = nil

  args.widget = widget.new(args.widget)

  local new_window = window_type(args)

  -- TODO: emit this automatically when the widget changes
  args.widget:emit_signal("attach")

  return new_window
end

return Window

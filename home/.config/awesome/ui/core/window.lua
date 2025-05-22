local widget = require("ui.core.widget")

---@class Window
local Window = {}

local function handle_attach_detach(w)
  if w.widget and w.widget.emit_signal then
    if w.visible then
      w.widget:emit_signal("attach")
    else
      w.widget:emit_signal("detach")
    end
  end
end

function Window.new(args)
  local window_constructor = args.window
  args.window = nil

  args.widget = widget.new(args.widget)

  local window = window_constructor(args)

  -- TODO: also emit attach/detach when the widget changes

  if window.widget and window.visible then
    window.widget:emit_signal("attach")
  end

  window:connect_signal("property::visible", handle_attach_detach)

  return window
end

return Window

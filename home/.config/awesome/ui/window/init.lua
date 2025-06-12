local Window = require("ui.core.window")

---@overload fun(args): table
local window = {
  Popup = require("ui.window.popup"),
}

---@diagnostic disable-next-line: param-type-mismatch
return setmetatable(window, {
  __call = function(_, w)
    return Window(w)
  end,
})

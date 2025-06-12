local Widget = require("ui.core.widget")
local tbl = require("helpers.table")

---@overload fun(args): table
local widgets = tbl.merge({
  Button = require("ui.widgets.button"),
  Calendar = require("ui.widgets.calendar"),
  Input = require("ui.widgets.input"),
}, require("ui.widgets.common"))

---@diagnostic disable-next-line: param-type-mismatch
return setmetatable(widgets, {
  __call = function(_, w)
    return Widget.new(w)
  end,
})

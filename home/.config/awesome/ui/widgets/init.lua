local awful = require("awful")
local wibox = require("wibox")

local Widget = require("ui.core.widget")
local container = require("ui.widgets.container")
local flexible = require("ui.widgets.flexible")
local flex = require("ui.layout.flex")

local function make_widget(widget_constructor, child_prop)
  return function(params)
    if child_prop and params[1] then
      params[child_prop] = params[child_prop] or params[1]
      params[1] = nil
    end
    params.widget = widget_constructor
    return Widget.new(params)
  end
end

local widgets = {
  -- Single-Widget Containers
  Container = make_widget(container),
  Center = make_widget(wibox.container.place),
  Flexible = make_widget(flexible),

  -- Layouts
  Column = make_widget(flex.vertical),
  Row = make_widget(flex.horizontal),

  -- Widgets
  -- TODO: merge ClientIcon and Image
  ClientIcon = make_widget(awful.widget.clienticon, "client"),
  Image = make_widget(wibox.widget.imagebox, "image"),
  ProgressBar = make_widget(wibox.widget.progressbar),
  Systray = make_widget(wibox.widget.systray),
  Text = make_widget(wibox.widget.textbox, "text"),
  TextClock = make_widget(wibox.widget.textclock, "format"),
}

---@diagnostic disable-next-line: param-type-mismatch
return setmetatable(widgets, {
  __call = function(_, w)
    return Widget.new(w)
  end,
})

local awful = require("awful")
local wibox = require("wibox")

local Widget = require("ui.core.widget")
local container = require("ui.widgets.container")
local flex = require("ui.layout.flex")

local function make_widget(widget_constructor, child_prop)
  return function(params)
    if child_prop then
      params[child_prop] = params[child_prop] or params[1]
    end
    params.widget = widget_constructor
    return Widget.new(params)
  end
end

local widgets = {
  -- Single-Widget Containers
  Container = make_widget(container),
  Center = make_widget(wibox.container.place),

  -- Layouts
  Column = make_widget(flex.vertical),
  Row = make_widget(flex.horizontal),

  -- TODO: Replace with Flexible/Expanded widget
  RowAlign = make_widget(wibox.layout.align.horizontal),
  RowFlex = make_widget(wibox.layout.flex.horizontal),
  RowFit = make_widget(require("ui.layout.fit").horizontal),

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

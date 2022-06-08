local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")
local gears = require("gears")

local function create_button(shape, color, command, c)
  local button = wibox.widget({
    widget = wibox.container.background,
    bg = color,
    shape = shape,
    forced_width = dpi(12),
    forced_height = dpi(12),
  })

  button:connect_signal("mouse::enter", function()
    button.bg = color
  end)

  button:connect_signal("mouse::leave", function()
    button.bg = color
  end)

  button:connect_signal("button::press", function()
    button.bg = color .. "cc"
  end)

  button:connect_signal("button::release", function()
    button.bg = beautiful.fg_focus
    command()
  end)

  local function dyna()
    if client.focus == c then
      button.bg = color
    else
      button.bg = beautiful.fg_normal .. "1A"
    end
  end

  c:connect_signal("focus", dyna)

  c:connect_signal("unfocus", dyna)
  return button
end

client.connect_signal("request::titlebars", function(c)
  local buttons = {
    awful.button({}, 1, function()
      c:activate({ context = "titlebar", action = "mouse_move" })
    end),
  }

  local titlebar = awful.titlebar(c, {
    position = "top",
    size = dpi(32),
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal,
  })

  titlebar:setup({
    {
      {
        nil,
        {
          widget = awful.titlebar.widget.titlewidget(c),
          buttons = buttons,
        },
        {
          create_button(gears.shape.circle, beautiful.colors.gold, function()
            awful.client.floating.toggle(c)
          end, c),
          create_button(gears.shape.circle, beautiful.colors.pine, function()
            c.maximized = not c.maximized
            c:raise()
          end, c),
          create_button(gears.shape.circle, beautiful.colors.love, function()
            c:kill()
          end, c),
          layout = wibox.layout.fixed.horizontal,
          spacing = dpi(18),
        },
        layout = wibox.layout.align.horizontal,
      },
      right = dpi(16),
      left = dpi(16),
      widget = wibox.container.margin,
    },
    widget = wibox.container.background,
  })
end)

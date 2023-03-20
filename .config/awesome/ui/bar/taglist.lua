local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helpers = require("helpers")

local taglist = function(s)
  local taglist_buttons = {
    awful.button({}, 1, function(t)
      t:view_only()
    end),
    awful.button({ modkey }, 1, function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
    end),
    awful.button({}, 4, function(t)
      awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
      awful.tag.viewprev(t.screen)
    end),
  }

  local taglist_widget = awful.widget.taglist({
    screen = s,
    filter = awful.widget.taglist.filter.noempty,
    layout = {
      spacing = dpi(4),
      layout = wibox.layout.fixed.horizontal,
    },
    buttons = taglist_buttons,
    style = {
      shape = helpers.shape.rounded_rect(4),
    },
    widget_template = {
      {
        {
          id = "text_role",
          widget = wibox.widget.textbox,
          halign = "center",
          valign = "center",
        },
        widget = wibox.container.place,
      },
      id = "background_role",
      bg = beautiful.bg_tasklist_active,
      forced_width = dpi(20),
      widget = wibox.container.background,
    },
  })

  return taglist_widget
end

return taglist

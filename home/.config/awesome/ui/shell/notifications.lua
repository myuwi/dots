local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gsurface = require("gears.surface")
local naughty = require("naughty")

local helpers = require("helpers")

local Window = require("ui.window")
local Container = require("ui.widgets").Container
local Column = require("ui.widgets").Column
local Row = require("ui.widgets").Row
local RowFlex = require("ui.widgets").RowFlex
local Image = require("ui.widgets").Image
local Text = require("ui.widgets").Text
local Button = require("ui.components").Button

naughty.config.defaults.app_name = "Notification"
naughty.config.defaults.ontop = true
naughty.config.defaults.screen = screen.primary
naughty.config.defaults.timeout = 6
naughty.config.defaults.title = "Notification"
naughty.config.defaults.position = "bottom_right"

-- Don't set notification image as the icon
naughty.disconnect_signal("request::icon", naughty.icon_path_handler)

-- Enable path and app_icon handling
-- NOTE: Falls back to an icon from an associated client (via `naughty.client_icon_handler`) if not found here
naughty.connect_signal("request::icon", function(n, context, hints)
  if context == "path" then
    n.icon = gsurface.load_uncached_silently(hints.path)
  elseif context == "app_icon" then
    n.icon = helpers.client.find_icon(hints.app_icon)
  end
end)

naughty.connect_signal("request::display", function(n)
  local notification_body_width = beautiful.notification_width - beautiful.notification_margin * 2

  -- Adjust for icon width and spacing
  if n.image ~= nil then
    notification_body_width = notification_body_width - dpi(60) - dpi(12)
  end

  local notification_body = Text {
    text = n.message,
    ellipsize = "none",
    valign = "top",
  }

  notification_body.forced_height = notification_body:get_height_for_width(notification_body_width, screen.primary)

  -- FIXME: Race condition (?) in "invoked" signal handler sometimes causes "dismissed_by_user"
  --        to be returned as the reason for dismissal even when action button is pressed
  local actions = RowFlex {
    spacing = dpi(6),
    visible = n.actions and #n.actions > 0,
    children = helpers.table.map(n.actions, function(action)
      local btn = Button {
        text = action:get_name(),
        buttons = {
          awful.button({}, 1, function()
            action:invoke(n)
          end),
        },
      }

      return btn
    end),
  }

  local notification_widget = Window {
    window = naughty.layout.box,
    notification = n,
    type = "notification",
    bg = beautiful.colors.transparent,
    widget_template = Container {
      bg = beautiful.bg_normal,
      border_color = beautiful.border_color,
      border_width = beautiful.border_width,
      radius = beautiful.border_radius,
      forced_width = beautiful.notification_width,
      padding = beautiful.notification_margin,

      Column {
        spacing = dpi(12),
        Row {
          spacing = dpi(6),
          Image {
            image = n.icon,
            forced_width = dpi(18),
            forced_height = dpi(18),
            visible = n.icon ~= nil,
          },
          Text { n.app_name },
        },
        Row {
          spacing = dpi(12),
          -- TODO: non-square images
          Image {
            image = n.image,
            forced_width = dpi(60),
            forced_height = dpi(60),
            clip_shape = helpers.shape.rounded_rect(dpi(3)),
            visible = n.image ~= nil,
          },
          Container {
            padding = { y = dpi(6) },
            Column {
              spacing = dpi(3),
              Text {
                text = n.title,
                font = beautiful.font_name .. " Bold " .. beautiful.font_size,
                forced_height = dpi(18),
              },
              notification_body,
            },
          },
        },
        actions,
      },
    },
  }

  local timeout = n.timeout

  -- Stop notification from disappearing when hovered
  local function notif_mouse_enter()
    n:reset_timeout(86400) -- a long time
  end

  local function notif_mouse_leave()
    n:reset_timeout(timeout)
  end

  notification_widget.buttons = {
    awful.button({}, 1, function()
      n:destroy(naughty.notification_closed_reason.dismissed_by_user)
    end),
    awful.button({}, 3, function()
      n:destroy(naughty.notification_closed_reason.expired)
    end),
  }

  notification_widget:connect_signal("mouse::enter", notif_mouse_enter)
  notification_widget:connect_signal("mouse::leave", notif_mouse_leave)

  n:connect_signal("destroyed", function(destroyed_notif, reason)
    notification_widget:disconnect_signal("mouse::enter", notif_mouse_enter)
    notification_widget:disconnect_signal("mouse::leave", notif_mouse_leave)

    if reason == naughty.notification_closed_reason.dismissed_by_user then
      local client = destroyed_notif.clients[1]
      if client then
        client.first_tag:view_only()
        client:activate()
      end
    end
  end)
end)

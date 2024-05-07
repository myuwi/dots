local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local lgi = require("lgi")
local Gio = lgi.Gio
local Gtk = lgi.require("Gtk", "3.0")
local wibox = require("wibox")

local helpers = require("helpers")

local gtk_theme = Gtk.IconTheme.new()
Gtk.IconTheme.set_custom_theme(gtk_theme, beautiful.icon_theme)

local app_list = wibox.widget({
  spacing = dpi(4),
  layout = wibox.layout.fixed.vertical,
})

local start_menu_widget = helpers.ui.popup({
  margins = 0,
  placement = function(w)
    -- TODO: Is it okay to do this here?
    w.screen = mouse.screen

    awful.placement.top_left(w, {
      margins = beautiful.useless_gap * 2,
      honor_workarea = true,
    })
  end,
  widget = {
    {
      {
        {
          {
            {
              {
                image = beautiful.icon_path .. "power_settings_new.svg",
                stylesheet = "* { fill:" .. beautiful.fg_normal .. " }",
                forced_width = dpi(18),
                forced_height = dpi(18),
                widget = wibox.widget.imagebox,
              },
              margins = dpi(9),
              widget = wibox.container.margin,
            },
            bg = beautiful.colors.muted .. "1a",
            shape = helpers.shape.rounded_rect(dpi(6)),
            widget = wibox.container.background,
          },
          valign = "bottom",
          widget = wibox.container.place,
        },
        margins = dpi(9),
        widget = wibox.container.margin,
      },
      bg = beautiful.colors.surface,
      widget = wibox.container.background,
    },
    {
      {
        app_list,
        {
          {
            {
              markup = helpers.ui.colorize_text("Search...", beautiful.colors.muted),
              forced_height = dpi(18),
              widget = wibox.widget.textbox,
            },
            margins = dpi(9),
            widget = wibox.container.margin,
          },
          bg = beautiful.colors.surface,
          shape = helpers.shape.rounded_rect(dpi(6)),
          widget = wibox.container.background,
        },
        spacing = dpi(6),
        layout = wibox.layout.fixed.vertical,
      },
      margins = dpi(9),
      widget = wibox.container.margin,
    },
    forced_width = dpi(336),
    layout = wibox.layout.align.horizontal,
  },
})

local function draw_app_list()
  app_list:reset()

  local apps = Gio.AppInfo.get_all()

  apps = helpers.table.filter(apps, function(app)
    return app:should_show()
  end)

  table.sort(apps, function(a, b)
    return a:get_name():lower() < b:get_name():lower()
  end)

  for i, app in ipairs(apps) do
    if i > 8 then
      break
    end

    local icon = gtk_theme:lookup_by_gicon(app:get_icon(), dpi(24), 0)

    if icon then
      icon = icon:get_filename()
    end

    local entry = wibox.widget({
      {
        {
          {
            image = icon,
            forced_width = dpi(24),
            forced_height = dpi(24),
            widget = wibox.widget.imagebox,
          },
          {
            text = app:get_name(),
            widget = wibox.widget.textbox,
          },
          buttons = {
            awful.button({ "Any" }, 1, function()
              app:launch()
            end),
          },
          spacing = dpi(12),
          layout = wibox.layout.fixed.horizontal,
        },
        margins = dpi(6),
        widget = wibox.container.margin,
      },
      bg = i == 1 and beautiful.colors.surface,
      shape = helpers.shape.rounded_rect(dpi(4)),
      widget = wibox.container.background,
    })

    app_list:add(entry)
  end

  start_menu_widget:_apply_size_now()
end

local click_away_handler = helpers.ui.create_click_away_handler(start_menu_widget, true)

local keygrabber

local function hide()
  start_menu_widget.visible = false
  click_away_handler.detach()
  keygrabber:stop()
end

local function setup_keygrabber()
  keygrabber = awful.keygrabber({
    mask_modkeys = true,
    keypressed_callback = function(self, mod, key, event)
      if event == "release" then
        return
      end

      -- require("naughty").notification({
      --   message = "Key pressed: " .. helpers.table.stringify({ mod = mod, key = key }),
      -- })

      if key == "Escape" then
        self:stop()
        hide()
      end
    end,
  })

  keygrabber:start()
end

local function show()
  client.focus = nil
  click_away_handler.attach(hide)

  draw_app_list()
  setup_keygrabber()

  start_menu_widget.visible = true
end

awesome.connect_signal("widgets::start_menu::show", show)

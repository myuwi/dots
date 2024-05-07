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

local selected_index = 1
local scroll_offset = 0
local page_size = 8

local all_apps = {}
local visible_apps = {}

local prompt

local app_list = wibox.widget({
  spacing = dpi(4),
  forced_height = dpi(36) * 8 + dpi(4) * 7,
  layout = wibox.layout.fixed.vertical,
})

local input = wibox.widget({
  markup = helpers.ui.colorize_text("Search...", beautiful.colors.muted),
  forced_height = dpi(18),
  widget = wibox.widget.textbox,
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
            input,
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

  for i, app in ipairs(visible_apps) do
    if i > scroll_offset + page_size then
      break
    end

    if i > scroll_offset then
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
            spacing = dpi(12),
            layout = wibox.layout.fixed.horizontal,
          },
          margins = dpi(6),
          widget = wibox.container.margin,
        },
        buttons = {
          awful.button({ "Any" }, 1, function()
            app:launch()
          end),
        },
        bg = i == selected_index and beautiful.colors.surface,
        shape = helpers.shape.rounded_rect(dpi(4)),
        widget = wibox.container.background,
      })

      entry._app = app

      app_list:add(entry)
    end
  end

  start_menu_widget:_apply_size_now()
end

local function filter_apps(apps, text)
  if text == "" then
    return apps
  end

  return helpers.table.filter(apps, function(app)
    return app:get_name():lower():find(text:lower(), 1, true)
  end)
end

local function clamp_selection()
  if #visible_apps > 0 and selected_index == 0 then
    selected_index = 1
  end

  if selected_index > #visible_apps then
    selected_index = #visible_apps
  end
end

local function set_query(text)
  if text == "" then
    input.markup = helpers.ui.colorize_text("Search...", beautiful.colors.muted)
  else
    input.markup = text
  end

  visible_apps = filter_apps(all_apps, text)
  clamp_selection()
  draw_app_list()
end

local function move_selection(amount)
  if amount == 0 then
    return
  end

  local new_index = selected_index + amount

  if new_index > #visible_apps then
    selected_index = new_index - #visible_apps
  elseif new_index < 1 then
    selected_index = #visible_apps - new_index
  else
    selected_index = new_index
  end

  if selected_index <= scroll_offset then
    scroll_offset = selected_index - 1
  elseif selected_index > scroll_offset + page_size then
    scroll_offset = selected_index - page_size
  end

  draw_app_list()
end

local click_away_handler = helpers.ui.create_click_away_handler(start_menu_widget, true)

local function hide()
  start_menu_widget.visible = false
  click_away_handler.detach()
  all_apps = {}
  visible_apps = {}

  prompt:stop()
end

local function show()
  scroll_offset = 0
  selected_index = 1

  local new_apps = Gio.AppInfo.get_all()

  new_apps = helpers.table.filter(new_apps, function(app)
    return app:should_show()
  end)

  table.sort(new_apps, function(a, b)
    return a:get_name():lower() < b:get_name():lower()
  end)

  all_apps = new_apps
  visible_apps = all_apps

  client.focus = nil
  click_away_handler.attach(hide)

  prompt:reset()
  prompt:start()

  draw_app_list()

  start_menu_widget.visible = true
end

prompt = require(... .. ".prompt")({
  keypressed_callback = function(_, key, event)
    if event == "release" then
      return
    end

    if key == "Escape" then
      hide()
    end

    if key == "Return" then
      local selected = app_list.children[selected_index - scroll_offset]

      if selected then
        selected._app:launch()
        hide()
      end
    end

    if key == "Up" then
      move_selection(-1)
    elseif key == "Down" then
      move_selection(1)
    end
  end,
  changed_callback = function(text)
    set_query(text)
  end,
})

awesome.connect_signal("widgets::start_menu::show", show)

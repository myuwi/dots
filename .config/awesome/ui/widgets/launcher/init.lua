local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gstring = require("gears.string")
local lgi = require("lgi")
local Gio = lgi.Gio
local Gtk = lgi.require("Gtk", "3.0")
local wibox = require("wibox")

local helpers = require("helpers")

local prompt = require(... .. ".prompt")

local launcher = {}

local gtk_theme = Gtk.IconTheme.new()
Gtk.IconTheme.set_custom_theme(gtk_theme, beautiful.icon_theme)

local selected_index = 1
local scroll_offset = 0
local page_size = 6

local all_apps = {}
local visible_apps = {}

local last_focused_client = nil

local input = wibox.widget({
  markup = helpers.ui.colorize_text("Search...", beautiful.colors.muted),
  widget = wibox.widget.textbox,
})

local input_prompt

local app_list = wibox.widget({
  spacing = dpi(6),
  layout = wibox.layout.fixed.vertical,
})

local no_results_text = wibox.widget({
  text = "",
  valign = "center",
  forced_height = dpi(16),
  widget = wibox.widget.textbox,
})

local no_results = wibox.widget({
  no_results_text,
  margins = dpi(12),
  widget = wibox.container.margin,
})

local launcher_widget = helpers.ui.popup({
  margins = dpi(12),
  forced_width = dpi(552),
  -- TODO: Don't jump around vertically when the number of results changes
  placement = awful.placement.centered,
  widget = {
    {
      input,
      margins = dpi(12),
      widget = wibox.container.margin,
    },
    app_list,
    spacing = dpi(12),
    layout = wibox.layout.fixed.vertical,
  },
})

local function create_app_entry(app, i)
  local icon = gtk_theme:lookup_by_gicon(app:get_icon(), dpi(28), 0)

  if icon then
    icon = icon:get_filename()
  end

  local entry = wibox.widget({
    {
      {
        {
          image = icon,
          forced_width = dpi(28),
          forced_height = dpi(28),
          widget = wibox.widget.imagebox,
        },
        {
          text = app:get_name(),
          widget = wibox.widget.textbox,
        },
        spacing = dpi(12),
        layout = wibox.layout.fixed.horizontal,
      },
      top = dpi(6),
      left = dpi(9),
      right = dpi(9),
      bottom = dpi(6),
      widget = wibox.container.margin,
    },
    bg = i == selected_index and beautiful.colors.surface,
    shape = helpers.shape.rounded_rect(dpi(4)),
    widget = wibox.container.background,
  })

  helpers.ui.add_hover_cursor(entry, "hand2")

  entry.launch = function()
    local cmd = app:get_commandline():gsub("%%[fFuU]", "")

    if app:get_boolean("Terminal") then
      cmd = "alacritty -e " .. cmd
    end

    awful.spawn(cmd, false)
    launcher.hide()
  end

  entry.buttons = {
    awful.button({ "Any" }, 1, function()
      entry.launch()
    end),
  }

  return entry
end

---@param text string
local function format_no_results(text)
  local no_results_format = 'No results for "%s"'

  local escaped = gstring.xml_escape(text) --[[@as string]]
  local input_text = helpers.ui.colorize_text(escaped, beautiful.colors.text)
  local formatted = no_results_format:format(input_text)

  return helpers.ui.colorize_text(formatted, beautiful.colors.muted)
end

local function draw_app_list(apps)
  app_list:reset()

  if #apps == 0 then
    app_list:add(no_results)

    no_results_text.markup = format_no_results(input.text)
    launcher_widget:_apply_size_now()
    return
  end

  for i, app in ipairs(apps) do
    if i > scroll_offset + page_size then
      break
    end

    if i > scroll_offset then
      local entry = create_app_entry(app, i)
      app_list:add(entry)
    end
  end

  launcher_widget:_apply_size_now()
end

local function filter_apps(apps, text)
  if text == "" then
    return apps
  end

  return helpers.table.filter(apps, function(app)
    return app:get_name():lower():find(text:lower(), 1, true)
      or helpers.table.any(app:get_keywords(), function(keyword)
        return keyword:lower():find(text:lower(), 1, true)
      end)
  end)
end

local function clamp_selection()
  scroll_offset = math.min(math.max(#visible_apps - page_size, 0), scroll_offset)
  selected_index = math.min(math.max(selected_index, 1), #visible_apps)
end

local function set_query(text)
  if text == "" then
    input.markup = helpers.ui.colorize_text("Search...", beautiful.colors.muted)
  else
    input.text = text
  end

  visible_apps = filter_apps(all_apps, text)
  clamp_selection()
  draw_app_list(visible_apps)
end

local function move_selection(amount)
  if amount == 0 then
    return
  end

  local new_index = selected_index + amount
  selected_index = (new_index - 1) % #visible_apps + 1

  -- Make sure scroll follows selection
  scroll_offset = math.min(math.max(scroll_offset, selected_index - page_size), selected_index - 1)

  draw_app_list(visible_apps)
end

input_prompt = prompt({
  keypressed_callback = function(_, key, event)
    if event == "release" then
      return
    end

    if key == "Escape" then
      launcher.cancel()
    end

    if key == "Return" then
      local selected = app_list.children[selected_index - scroll_offset]

      if selected then
        selected.launch()
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

-- TODO: Should this be a backdrop instead?
local click_away_handler = helpers.ui.create_click_away_handler(launcher_widget, false)

function launcher.hide()
  launcher_widget.visible = false
  last_focused_client = nil
  click_away_handler.detach()

  all_apps = {}
  visible_apps = {}

  input_prompt:stop()
end

function launcher.cancel()
  client.focus = last_focused_client
  launcher.hide()
end

function launcher.show()
  scroll_offset = 0
  selected_index = 1

  local new_apps = Gio.DesktopAppInfo.get_all()

  new_apps = helpers.table.filter(new_apps, function(app)
    return not app:get_nodisplay()
  end)

  table.sort(new_apps, function(a, b)
    return a:get_name():lower() < b:get_name():lower()
  end)

  all_apps = new_apps
  visible_apps = all_apps

  last_focused_client = client.focus
  client.focus = nil
  click_away_handler.attach(launcher.cancel)

  input_prompt:reset()
  input_prompt:start()

  draw_app_list(visible_apps)

  launcher_widget.visible = true
end

awesome.connect_signal("widgets::launcher::show", launcher.show)

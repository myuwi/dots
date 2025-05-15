local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gstring = require("gears.string")
local lgi = require("lgi")
local Gio = lgi.Gio
local Gtk = lgi.require("Gtk", "3.0")
local wibox = require("wibox")

local helpers = require("helpers")
local widget = require("ui.widgets")

local launcher = {}

local gtk_theme = Gtk.IconTheme.new()
Gtk.IconTheme.set_custom_theme(gtk_theme, beautiful.icon_theme)

local selected_index = 1
local scroll_offset = 0
local page_size = 6

local all_apps = {}
local visible_apps = {}

local last_focused_client = nil

local text_input = widget.input({
  placeholder = helpers.ui.colorize_text("Search...", beautiful.colors.muted),
})

-- TODO: extract as a reusable scrollable list widget?
local app_list = wibox.widget({
  spacing = dpi(6),
  layout = wibox.layout.fixed.vertical,
})

local no_results_text = wibox.widget({
  text = "",
  valign = "center",
  forced_height = dpi(18),
  widget = wibox.widget.textbox,
})

local no_results = wibox.widget({
  no_results_text,
  margins = dpi(12),
  widget = wibox.container.margin,
})

local launcher_widget_max_height = 0

local launcher_widget = widget.popup({
  forced_width = dpi(576),
  -- TODO: A better way to do this
  placement = function(w)
    if w.height > launcher_widget_max_height then
      launcher_widget_max_height = w.height
    end

    local top_offset = (w.screen.geometry.height - launcher_widget_max_height) / 2

    awful.placement.top(w, {
      offset = {
        y = top_offset,
      },
    })
  end,
  widget = {
    {
      text_input,
      margins = dpi(12),
      widget = wibox.container.margin,
    },
    -- TODO: scrollbar to indicate list position
    app_list,
    spacing = dpi(12),
    layout = wibox.layout.fixed.vertical,
  },
})

---@param i integer
local function launch_at_index(i)
  local app = visible_apps[i]
  local cmd = app:get_commandline():gsub("%%[fFuU]", "")

  if app:get_boolean("Terminal") then
    cmd = "alacritty -e " .. cmd
  end

  awful.spawn(cmd, false)
  launcher.hide()
end

local function redraw_highlights()
  for i, c in ipairs(app_list.children) do
    local index = i + scroll_offset
    c.bg = index == selected_index and beautiful.colors.surface or beautiful.colors.transparent
  end
end

local function create_app_entry(app, i)
  local icon = gtk_theme:lookup_by_gicon(app:get_icon(), dpi(30), 0)

  if icon then
    icon = icon:get_filename()
  end

  local entry = wibox.widget({
    {
      {
        {
          image = icon,
          forced_width = dpi(30),
          forced_height = dpi(30),
          widget = wibox.widget.imagebox,
        },
        {
          text = app:get_name(),
          widget = wibox.widget.textbox,
        },
        spacing = dpi(9),
        layout = wibox.layout.fixed.horizontal,
      },
      top = dpi(6),
      left = dpi(9),
      right = dpi(9),
      bottom = dpi(6),
      widget = wibox.container.margin,
    },
    bg = i == selected_index and beautiful.colors.surface or beautiful.colors.transparent,
    shape = helpers.shape.rounded_rect(dpi(4)),
    widget = wibox.container.background,
  })

  entry.buttons = {
    awful.button({ "Any" }, 1, function()
      launch_at_index(i)
    end),
  }

  entry:connect_signal("mouse::enter", function()
    selected_index = i
    redraw_highlights()
  end)

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

-- TODO(perf): reuse elements instead of discarding them on every render
local function draw_app_list(apps)
  app_list:reset()

  if #apps > 0 then
    local num_visible_apps = math.min(page_size, #apps)

    for i = 1 + scroll_offset, num_visible_apps + scroll_offset do
      local app = apps[i]
      local entry = create_app_entry(app, i)
      app_list:add(entry)
    end
  else
    app_list:add(no_results)
    no_results_text.markup = format_no_results(text_input.text)
  end

  launcher_widget:_apply_size_now()
end

local function move_selection(amount)
  local new_index = selected_index + amount
  selected_index = ((new_index - 1) % #visible_apps) + 1

  -- Make sure scroll follows selection
  scroll_offset = math.min(math.max(scroll_offset, selected_index - page_size), selected_index - 1)

  draw_app_list(visible_apps)
end

local function scroll_list(amount)
  local min_scroll_offset = 0
  local max_scroll_offset = #visible_apps - math.min(page_size, #visible_apps)
  local new_offset = math.min(math.max(scroll_offset + amount, min_scroll_offset), max_scroll_offset)

  -- Update only if needed
  if new_offset ~= scroll_offset then
    scroll_offset = new_offset

    draw_app_list(visible_apps)
  end
end

-- TODO: declarative keybind handling?
text_input.keypressed_callback = function(mods, key)
  if key == "Escape" then
    launcher.cancel()
  end

  if key == "Return" then
    launch_at_index(selected_index)
  end

  local shift = mods[1] == "Shift"

  if key == "Tab" and shift or key == "Up" then
    move_selection(-1)
  elseif key == "Tab" or key == "Down" then
    move_selection(1)
  end
end

app_list.buttons = {
  awful.button({}, 4, function()
    scroll_list(-1)
  end),
  awful.button({}, 5, function()
    scroll_list(1)
  end),
}

local function filter_apps(apps, text)
  if text == "" then
    return apps
  end

  local filtered_apps = helpers.table.filter(apps, function(app)
    return app:get_name():lower():find(text:lower(), 1, true)
      or helpers.table.any(app:get_keywords(), function(keyword)
        return keyword:lower():find(text:lower(), 1, true)
      end)
  end)

  table.sort(filtered_apps, function(a, b)
    local a_name = a:get_name():lower()
    local b_name = b:get_name():lower()

    local a_match = a_name:find(text:lower(), 1, true) ~= nil
    local b_match = b_name:find(text:lower(), 1, true) ~= nil

    if a_match == b_match then
      return a_name < b_name
    end

    return a_match
  end)

  return filtered_apps
end

local function clamp_selection()
  scroll_offset = math.min(math.max(#visible_apps - page_size, 0), scroll_offset)
  selected_index = math.min(math.max(selected_index, 1), #visible_apps)
end

local function set_filter(text)
  visible_apps = filter_apps(all_apps, text)
  clamp_selection()
  draw_app_list(visible_apps)
end

text_input.changed_callback = set_filter

-- TODO: Should this be a backdrop instead?
local click_away_handler = helpers.ui.create_click_away_handler(launcher_widget, false)

function launcher.hide()
  launcher_widget.visible = false
  last_focused_client = nil
  click_away_handler.detach()

  all_apps = {}
  visible_apps = {}

  text_input:unfocus()
end

function launcher.cancel()
  client.focus = last_focused_client
  launcher.hide()
end

function launcher.show()
  scroll_offset = 0
  selected_index = 1

  local new_apps = helpers.table.filter(Gio.DesktopAppInfo.get_all(), function(app)
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

  text_input:reset()
  text_input:focus()

  draw_app_list(visible_apps)

  launcher_widget.visible = true
end

awesome.connect_signal("shell::launcher::show", launcher.show)

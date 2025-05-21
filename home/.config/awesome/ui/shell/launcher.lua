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

local signal = require("ui.core.signal")
local computed = require("ui.core.signal.computed")
local effect = require("ui.core.signal.effect")
local map = require("ui.core.signal.map")

local launcher = {}

local gtk_theme = Gtk.IconTheme.new()
Gtk.IconTheme.set_custom_theme(gtk_theme, beautiful.icon_theme)

local page_size = 6

-- Signals

local query = signal("")
local selected_index = signal(1)
local scroll_position = signal(0)

local all_apps = signal({})

local function filter_apps(apps, query_text)
  if query_text == "" then
    return apps
  end

  local filtered_apps = helpers.table.filter(apps, function(app)
    return app:get_name():lower():find(query_text:lower(), 1, true)
      or helpers.table.any(app:get_keywords(), function(keyword)
        return keyword:lower():find(query_text:lower(), 1, true)
      end)
  end)

  table.sort(filtered_apps, function(a, b)
    local a_name = a:get_name():lower()
    local b_name = b:get_name():lower()

    local a_match = a_name:find(query_text:lower(), 1, true) ~= nil
    local b_match = b_name:find(query_text:lower(), 1, true) ~= nil

    if a_match == b_match then
      return a_name < b_name
    end

    return a_match
  end)

  return filtered_apps
end

-- TODO: batch(fn)
local filtered_apps = computed(function()
  return filter_apps(all_apps.value, query.value)
end)

local function clamp_selection()
  scroll_position.value = math.min(math.max(#filtered_apps.value - page_size, 0), scroll_position.value)
  selected_index.value = math.min(math.max(selected_index.value, 1), #filtered_apps.value)
end

effect(clamp_selection)

-- Functions

local function launch(app)
  if not app then
    return
  end

  local cmd = app:get_commandline():gsub("%%[fFuU]", "")

  if app:get_boolean("Terminal") then
    cmd = "alacritty -e " .. cmd
  end

  awful.spawn(cmd, false)
end

local function move_selection(amount)
  local new_index = selected_index.value + amount
  selected_index.value = ((new_index - 1) % #filtered_apps.value) + 1

  -- Make sure scroll follows selection
  scroll_position.value =
    math.min(math.max(scroll_position.value, selected_index.value - page_size), selected_index.value - 1)
end

local function scroll_list(amount)
  local min_scroll_offset = 0
  local max_scroll_offset = #filtered_apps.value - math.min(page_size, #filtered_apps.value)
  local new_offset = math.min(math.max(scroll_position.value + amount, min_scroll_offset), max_scroll_offset)

  -- Update only if needed
  if new_offset ~= scroll_position.value then
    scroll_position.value = new_offset
  end
end

local last_focused_client = nil

-- Widgets

local text_input = widget.input({
  placeholder = "Search for apps...",
})

---@param text string
local function format_no_results(text)
  local no_results_format = 'No results for "%s"'

  local escaped = gstring.xml_escape(text) --[[@as string]]
  local input_text = helpers.ui.colorize_text(escaped, beautiful.fg_normal)
  local formatted = no_results_format:format(input_text)

  return helpers.ui.colorize_text(formatted, beautiful.fg_unfocus)
end

local no_results = widget.new({
  {
    markup = map(query, format_no_results),
    valign = "center",
    forced_height = dpi(18),
    widget = wibox.widget.textbox,
  },
  margins = dpi(12),
  widget = wibox.container.margin,
})

local function create_entry(app, i)
  local icon = gtk_theme:lookup_by_gicon(app:get_icon(), dpi(30), 0)

  if icon then
    icon = icon:get_filename()
  end

  local entry = widget.new({
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
    bg = computed(function()
      return i == selected_index.value and beautiful.bg_focus or beautiful.colors.transparent
    end),
    buttons = {
      awful.button({ "Any" }, 1, function()
        launch(app)
        launcher.hide()
      end),
    },
    shape = helpers.shape.rounded_rect(dpi(4)),
    widget = wibox.container.background,
  })

  entry:connect_signal("mouse::enter", function()
    selected_index.value = i
  end)

  return entry
end

-- TODO(perf): reuse elements instead of discarding them on every render?
local function create_entries(apps)
  if #apps <= 0 then
    return no_results
  end

  local children = {}
  local num_visible_apps = math.min(page_size, #apps)

  for i = 1 + scroll_position.value, num_visible_apps + scroll_position.value do
    local app = apps[i]

    -- FIXME: Make it so this if isn't needed (by batching signals?)
    if app then
      local entry = create_entry(app, i)
      children[#children + 1] = entry
    end
  end

  return children
end

-- TODO: extract as a reusable scrollable list widget?
local app_list = widget.new({
  children = map(filtered_apps, create_entries),
  spacing = dpi(6),
  layout = wibox.layout.fixed.vertical,
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

-- Controls

-- TODO: declarative keybind handling?
text_input.keypressed_callback = function(mods, key)
  if key == "Escape" then
    launcher.cancel()
  end

  if key == "Return" then
    local app = filtered_apps.value[selected_index.value]
    launch(app)
    launcher.hide()
  end

  local shift = mods[1] == "Shift"

  if key == "Tab" and shift or key == "Up" then
    move_selection(-1)
  elseif key == "Tab" or key == "Down" then
    move_selection(1)
  end
end

text_input.changed_callback = function(text)
  query.value = text
end

app_list.buttons = {
  awful.button({}, 4, function()
    scroll_list(-1)
  end),
  awful.button({}, 5, function()
    scroll_list(1)
  end),
}

-- Setup

-- TODO: Should this be a backdrop instead?
local click_away_handler = helpers.ui.create_click_away_handler(launcher_widget, false)

function launcher.hide()
  launcher_widget.visible = false
  last_focused_client = nil
  click_away_handler.detach()

  all_apps.value = {}

  text_input:unfocus()
end

function launcher.cancel()
  client.focus = last_focused_client
  launcher.hide()
end

function launcher.show()
  scroll_position.value = 0
  selected_index.value = 1

  local new_apps = helpers.table.filter(Gio.DesktopAppInfo.get_all(), function(app)
    return not app:get_nodisplay()
  end)

  table.sort(new_apps, function(a, b)
    return a:get_name():lower() < b:get_name():lower()
  end)

  all_apps.value = new_apps

  last_focused_client = client.focus
  client.focus = nil
  click_away_handler.attach(launcher.cancel)

  text_input:reset()
  text_input:focus()

  launcher_widget.visible = true
end

awesome.connect_signal("shell::launcher::show", launcher.show)

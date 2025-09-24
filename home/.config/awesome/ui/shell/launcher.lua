local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gstring = require("gears.string")
local lgi = require("lgi")
local GioUnix = lgi.GioUnix
local Gtk = lgi.require("Gtk", "3.0")

local helpers = require("helpers")
local Window = require("ui.window")
local Container = require("ui.widgets").Container
local Column = require("ui.widgets").Column
local Row = require("ui.widgets").Row
local Image = require("ui.widgets").Image
local Text = require("ui.widgets").Text
local Input = require("ui.components").Input

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

local filtered_apps = computed(function()
  return filter_apps(all_apps:get(), query:get())
end)

local function clamp_selection()
  scroll_position:set(math.min(math.max(#filtered_apps:get() - page_size, 0), scroll_position:peek()))
  selected_index:set(math.max(math.min(selected_index:peek(), #filtered_apps:get()), 1))
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
  launcher.hide()
end

local function move_selection(amount)
  if #filtered_apps:get() == 0 then
    return
  end

  local new_index = selected_index:get() + amount
  selected_index:set(((new_index - 1) % #filtered_apps:get()) + 1)

  -- Make sure scroll follows selection
  scroll_position:set(
    math.min(math.max(scroll_position:get(), selected_index:get() - page_size), selected_index:get() - 1)
  )
end

local function scroll_list(amount)
  local min_scroll_offset = 0
  local max_scroll_offset = #filtered_apps:get() - math.min(page_size, #filtered_apps:get())
  local new_offset = math.min(math.max(scroll_position:get() + amount, min_scroll_offset), max_scroll_offset)

  -- Update only if needed
  if new_offset ~= scroll_position:get() then
    scroll_position:set(new_offset)
  end
end

local last_focused_client = nil

-- Widgets

local text_input = Input {
  placeholder = "Search for apps...",
}

---@param text string
local function format_no_results(text)
  local no_results_format = 'No results for "%s"'

  local escaped = gstring.xml_escape(text) --[[@as string]]
  local input_text = helpers.ui.colorize_text(escaped, beautiful.fg_normal)
  local formatted = no_results_format:format(input_text)

  return helpers.ui.colorize_text(formatted, beautiful.fg_unfocus)
end

local no_results = Container {
  padding = dpi(12),

  Text {
    markup = map(query, format_no_results),
    valign = "center",
    forced_height = dpi(18),
  },
}

local function create_entry(app, i)
  local icon = gtk_theme:lookup_by_gicon(app:get_icon(), dpi(30), 0)

  if icon then
    icon = icon:get_filename()
  end

  local entry = Container {
    bg = computed(function()
      return i == selected_index:get() and beautiful.bg_focus or nil
    end),
    padding = { x = dpi(9), y = dpi(6) },
    radius = dpi(4),
    on_click = function()
      launch(app)
    end,
    on_mouse_enter = function()
      selected_index:set(i)
    end,

    Row {
      spacing = dpi(9),
      Image {
        image = icon,
        forced_width = dpi(30),
        forced_height = dpi(30),
      },
      Text { app:get_name() },
    },
  }

  return entry
end

-- TODO(perf): reuse elements instead of discarding them on every render?
local function create_entries(apps)
  if #apps <= 0 then
    return no_results
  end

  local children = {}
  local num_visible_apps = math.min(page_size, #apps)

  for i = 1 + scroll_position:get(), num_visible_apps + scroll_position:get() do
    local app = apps[i]
    local entry = create_entry(app, i)
    children[#children + 1] = entry
  end

  return children
end

-- TODO: extract as a reusable scrollable list widget?
local app_list = Column {
  spacing = dpi(6),
  on_wheel_up = function()
    scroll_list(-1)
  end,
  on_wheel_down = function()
    scroll_list(1)
  end,

  map(filtered_apps, create_entries),
}

local launcher_widget_max_height = 0

local launcher_widget = Window.Popup {
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

  Column {
    spacing = dpi(12),
    Container {
      padding = dpi(12),
      text_input,
    },
    -- TODO: scrollbar to indicate list position
    app_list,
  },
}

-- Controls

-- TODO: declarative keybind handling?
text_input.keypressed_callback = function(mods, key)
  if key == "Escape" then
    launcher.cancel()
  end

  if key == "Return" then
    local app = filtered_apps:get()[selected_index:get()]
    launch(app)
  end

  local shift = mods[1] == "Shift"

  if key == "Tab" and shift or key == "Up" then
    move_selection(-1)
  elseif key == "Tab" or key == "Down" then
    move_selection(1)
  end
end

text_input.changed_callback = function(text)
  query:set(text)
end

-- Setup

-- TODO: Should this be a backdrop instead?
local click_away_handler = helpers.ui.create_click_away_handler(launcher_widget, false)

function launcher.hide()
  launcher_widget.visible = false
  last_focused_client = nil
  click_away_handler.detach()

  text_input:reset()
  text_input:unfocus()

  all_apps:set({})
end

function launcher.cancel()
  -- FIXME: Error here?
  client.focus = last_focused_client
  launcher.hide()
end

function launcher.show()
  scroll_position:set(0)
  selected_index:set(1)

  local new_apps = helpers.table.filter(GioUnix.DesktopAppInfo.get_all(), function(app)
    return not app:get_nodisplay()
  end)

  table.sort(new_apps, function(a, b)
    return a:get_name():lower() < b:get_name():lower()
  end)

  all_apps:set(new_apps)

  last_focused_client = client.focus
  client.focus = nil
  click_away_handler.attach(launcher.cancel)

  text_input:focus()

  launcher_widget.visible = true
end

awesome.connect_signal("shell::launcher::show", launcher.show)

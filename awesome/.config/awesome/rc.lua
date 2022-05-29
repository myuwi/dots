local theme = "mwi"

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local naughty = require("naughty")
require("awful.autofocus")

-- Globals
config_dir = gears.filesystem.get_configuration_dir()
modkey = "Mod4"
apps = {
  terminal = "alacritty",
}

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then
      return
    end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err),
    })
    in_error = false
  end)
end

-- Themes define colours, icons, font and wallpapers.
beautiful.init(config_dir .. "themes/" .. theme .. "/theme.lua")

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.max,
}

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
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
  end)
)

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  -- Create the panel
  local panel = awful.wibar({
    position = "top",
    screen = s,
    height = dpi(40),
    bg = beautiful.bg_panel,
  })

  -- Add widgets to the panel
  panel:setup({
    -- Left widgets
    {
      -- Tag List
      -- awful.widget.taglist({
      --   screen = s,
      --   filter = awful.widget.taglist.filter.all,
      --   buttons = taglist_buttons,
      -- }),
      require("widgets.panel.taglist")(s),
      layout = wibox.layout.fixed.horizontal,
    },
    -- Middle widget
    require("widgets.panel.tasklist")(s),
    -- Right widgets
    {
      require("widgets.panel.systray")(),
      require("widgets.panel.clock")(),
      require("widgets.panel.layoutbox")(s),
      layout = wibox.layout.fixed.horizontal,
    },
    layout = wibox.layout.align.horizontal,
  })
end)

-- Key bindings
local keys = require("keys")

-- Set global keys
root.keys(keys.globalkeys)

-- Rules
awful.rules.rules = require("rules")(keys.clientkeys, keys.clientbuttons)

-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c, context)
  -- Set the windows at the slave
  if not awesome.startup then
    awful.client.setslave(c)

    -- Center floating windows when they are spawned
    if c.floating then
      awful.placement.centered(c)
    end
  end

  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Autostart
require("autostart")

-- Configure monitors
require("monitors")

require("components.volume")

require("modules.ruled")

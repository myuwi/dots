local gears = require("gears")
local awful = require("awful")

local keys = {}

keys.globalkeys = gears.table.join(
  awful.key({ modkey }, "Left", awful.tag.viewprev, {
    description = "view previous",
    group = "tag",
  }),
  awful.key({ modkey }, "Right", awful.tag.viewnext, {
    description = "view next",
    group = "tag",
  }),
  awful.key({ modkey }, "Escape", awful.tag.history.restore, {
    description = "go back",
    group = "tag",
  }),
  awful.key({ modkey }, "j", function()
    awful.client.focus.byidx(1)
  end, {
    description = "focus next by index",
    group = "client",
  }),
  awful.key({ modkey }, "k", function()
    awful.client.focus.byidx(-1)
  end, {
    description = "focus previous by index",
    group = "client",
  }),
  -- Layout manipulation
  awful.key({ modkey }, "space", function()
    awful.layout.inc(1)
  end, {
    description = "select next layout",
    group = "layout",
  }),
  awful.key({ modkey, "Shift" }, "space", function()
    awful.layout.inc(-1)
  end, {
    description = "select previous layout",
    group = "layout",
  }),
  awful.key({ modkey, "Shift" }, "j", function()
    awful.client.swap.byidx(1)
  end, {
    description = "swap with next client by index",
    group = "client",
  }),
  awful.key({ modkey, "Shift" }, "k", function()
    awful.client.swap.byidx(-1)
  end, {
    description = "swap with previous client by index",
    group = "client",
  }),
  awful.key({ modkey, "Control" }, "j", function()
    awful.screen.focus_relative(1)
  end, {
    description = "focus the next screen",
    group = "screen",
  }),
  awful.key({ modkey, "Control" }, "k", function()
    awful.screen.focus_relative(-1)
  end, {
    description = "focus the previous screen",
    group = "screen",
  }),
  awful.key({ modkey }, "u", awful.client.urgent.jumpto, {
    description = "jump to urgent client",
    group = "client",
  }),
  awful.key({ modkey }, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end, {
    description = "go back",
    group = "client",
  }),
  -- Terminal
  awful.key({ modkey }, "Return", function()
    awful.spawn(apps.terminal, false)
  end, {
    description = "open a terminal",
    group = "launcher",
  }),
  -- dmenu
  awful.key({ modkey }, "d", function()
    awful.spawn("dmenu_run -c -p 'run'", false)
  end, {
    description = "run dmenu",
    group = "launcher",
  }),
  -- Toggle picom
  awful.key({ modkey }, "p", function()
    awful.spawn.with_shell("pgrep -ix picom > /dev/null && killall picom || picom &")
  end, {
    description = "toggle picom",
    group = "misc",
  }),
  awful.key({ modkey, "Control" }, "r", awesome.restart, {
    description = "reload awesome",
    group = "awesome",
  }),
  awful.key({ modkey }, "l", function()
    awful.tag.incmwfact(0.05)
  end, {
    description = "increase master width factor",
    group = "layout",
  }),
  awful.key({ modkey }, "h", function()
    awful.tag.incmwfact(-0.05)
  end, {
    description = "decrease master width factor",
    group = "layout",
  }),
  awful.key({ modkey, "Shift" }, "h", function()
    awful.tag.incnmaster(1, nil, true)
  end, {
    description = "increase the number of master clients",
    group = "layout",
  }),
  awful.key({ modkey, "Shift" }, "l", function()
    awful.tag.incnmaster(-1, nil, true)
  end, {
    description = "decrease the number of master clients",
    group = "layout",
  }),
  awful.key({ modkey, "Control" }, "h", function()
    awful.tag.incncol(1, nil, true)
  end, {
    description = "increase the number of columns",
    group = "layout",
  }),
  awful.key({ modkey, "Control" }, "l", function()
    awful.tag.incncol(-1, nil, true)
  end, {
    description = "decrease the number of columns",
    group = "layout",
  }),
  -- Screenshot
  awful.key({ "Control" }, "Print", function()
    awful.spawn("flameshot gui", false)
  end, {
    description = "take an area screenshot",
    group = "screen",
  }),
  -- Volume keys
  awful.key({}, "XF86AudioRaiseVolume", function()
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%", false)
    awesome.emit_signal("volume_change")
  end, {
    description = "volume up",
    group = "media controls",
  }),
  awful.key({}, "XF86AudioLowerVolume", function()
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%", false)
    awesome.emit_signal("volume_change")
  end, {
    description = "volume down",
    group = "media controls",
  }),
  awful.key({}, "XF86AudioMute", function()
    awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle", false)
  end, {
    description = "volume mute",
    group = "media controls",
  }),
  -- Media controls
  awful.key({}, "XF86AudioPlay", function()
    awful.spawn("playerctl play-pause", false)
  end, {
    description = "media play",
    group = "media controls",
  }),
  awful.key({}, "XF86AudioNext", function()
    awful.spawn("playerctl next", false)
  end, {
    description = "media next",
    group = "media controls",
  }),
  awful.key({}, "XF86AudioPrev", function()
    awful.spawn("playerctl previous", false)
  end, {
    description = "media previous",
    group = "media controls",
  }),
  awful.key({}, "XF86AudioStop", function()
    awful.spawn("playerctl stop", false)
  end, {
    description = "media stop",
    group = "media controls",
  }),
  -- Brightness controls
  awful.key({}, "XF86MonBrightnessUp", function()
    awful.spawn("backlightctl -i 5", false)
  end, {
    description = "brightness up",
    group = "brightness",
  }),
  awful.key({}, "XF86MonBrightnessDown", function()
    awful.spawn("backlightctl -d 5", false)
  end, {
    description = "brightness down",
    group = "brightness",
  }),
  awful.key({}, "XF86MonBrightnessDown", function()
    awful.spawn("backlightctl -d 5", false)
  end, {
    description = "brightness down",
    group = "brightness",
  })
)

keys.clientkeys = gears.table.join(
  awful.key({ modkey }, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, {
    description = "toggle fullscreen",
    group = "client",
  }),
  awful.key({ modkey, "Shift" }, "q", function(c)
    c:kill()
  end, {
    description = "close",
    group = "client",
  }),
  awful.key({ modkey, "Shift" }, "f", awful.client.floating.toggle, {
    description = "toggle floating",
    group = "client",
  }),
  awful.key({ modkey, "Control" }, "Return", function(c)
    c:swap(awful.client.getmaster())
  end, {
    description = "move to master",
    group = "client",
  }),
  awful.key({ modkey }, "o", function(c)
    c:move_to_screen()
  end, {
    description = "move to screen",
    group = "client",
  }),
  awful.key({ modkey }, "t", function(c)
    c.ontop = not c.ontop
  end, {
    description = "toggle keep on top",
    group = "client",
  }),
  awful.key({ modkey }, "m", function(c)
    c.maximized = not c.maximized
    c:raise()
  end, {
    description = "(un)maximize",
    group = "client",
  }),
  awful.key({ modkey }, "c", function(c)
    if c.floating then
      awful.placement.centered(c)
    end
  end, {
    description = "center a client",
    group = "client",
  })
)

keys.clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", {
      raise = true,
    })
  end),
  awful.button({ modkey }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", {
      raise = true,
    })
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", {
      raise = true,
    })
    awful.mouse.client.resize(c)
  end)
)

for i = 1, 9 do
  keys.globalkeys = gears.table.join(
    keys.globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        tag:view_only()
      end
    end, {
      description = "view tag #" .. i,
      group = "tag",
    }),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end, {
      description = "toggle tag #" .. i,
      group = "tag",
    }),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end, {
      description = "move focused client to tag #" .. i,
      group = "tag",
    })
  )
end

return keys

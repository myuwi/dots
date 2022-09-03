local awful = require("awful")
local naughty = require("naughty")
local helpers = require("helpers")
local gears = require("gears")

-- Global keybindings
awful.keyboard.append_global_keybindings({
  awful.key({ modkey }, "Left", awful.tag.viewprev, {
    description = "view previous",
    group = "tag",
  }),
  awful.key({ modkey }, "Right", awful.tag.viewnext, {
    description = "view next",
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
  awful.key({ modkey }, "s", function()
    awful.layout.inc(1)
  end, {
    description = "select next layout",
    group = "layout",
  }),
  awful.key({ modkey, "Shift" }, "s", function()
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
    awesome.emit_signal("window_switcher::open", 1)
  end, {
    description = "go back",
    group = "client",
  }),
  awful.key({ modkey, "Shift" }, "Tab", function()
    awesome.emit_signal("window_switcher::open", -1)
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
  -- rofi
  awful.key({ modkey }, "d", function()
    awful.spawn("rofi -show drun", false)
  end, {
    description = "run rofi",
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
  awful.key({}, "Print", function()
    helpers.misc.take_screenshot(0)
  end, {
    description = "take a screenshot of a specific window",
    group = "screen",
  }),
  awful.key({ "Shift" }, "Print", function()
    helpers.misc.take_screenshot(32)
  end, {
    description = "take a screenshot of a specific window",
    group = "screen",
  }),
})

-- Volume, Media and Brightness keys
awful.keyboard.append_global_keybindings({
  -- Volume keys
  awful.key({}, "XF86AudioRaiseVolume", function()
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%", false)
  end, {
    description = "volume up",
    group = "volume controls",
  }),
  awful.key({}, "XF86AudioLowerVolume", function()
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%", false)
  end, {
    description = "volume down",
    group = "volume controls",
  }),
  awful.key({}, "XF86AudioMute", function()
    awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle", false)
  end, {
    description = "volume mute",
    group = "volume controls",
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
    awful.spawn("brightnessctl set +5%", false)
  end, {
    description = "brightness up",
    group = "brightness",
  }),
  awful.key({}, "XF86MonBrightnessDown", function()
    awful.spawn("brightnessctl set 5%-", false)
  end, {
    description = "brightness down",
    group = "brightness",
  }),
})

-- Tag navigation keybindings
awful.keyboard.append_global_keybindings({
  awful.key({
    modifiers = { modkey },
    keygroup = "numrow",
    description = "view tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
    end,
  }),
  awful.key({
    modifiers = { modkey, "Control" },
    keygroup = "numrow",
    description = "toggle tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end,
  }),
  awful.key({
    modifiers = { modkey, "Shift" },
    keygroup = "numrow",
    description = "move focused client to tag",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end,
  }),
})

-- Client keybindings
client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings({
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
    awful.key({ modkey }, "c", function(c)
      if c.floating then
        helpers.placement.centered(c)
      end
    end, {
      description = "center a client",
      group = "client",
    }),
  })

  helpers.misc.command_exists("fcitx5", function()
    local Control_L = 37
    local Shift_L = 50
    local Super_L = 133

    -- Input method bindings
    awful.keyboard.append_client_keybindings({
      awful.key({ modkey }, "space", function()
        helpers.input.fcitx_toggle()
      end, {
        description = "toggle input method",
        group = "input",
      }),
      awful.key({ modkey, "Control" }, "space", function()
        helpers.input.fcitx_status(function(mode)
          if mode == 2 then
            helpers.input.key_up("space")
            helpers.input.key("Hiragana", { Super_L, Control_L })
          end
        end)
      end, {
        description = "set mozc mode to hiragana",
        group = "input",
      }),
      awful.key({ modkey, "Shift" }, "space", function()
        helpers.input.fcitx_status(function(mode)
          if mode == 2 then
            helpers.input.key_up("space")
            helpers.input.key("Katakana", { Super_L, Shift_L })
          end
        end)
      end, {
        description = "set mozc mode to katakana",
        group = "input",
      }),
    })
  end)
end)

-- Desktop mousebindings
awful.mouse.append_global_mousebindings({
  awful.button({}, 1, function()
    client.focus = nil
  end),
})

-- Client mousebindings
client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings({
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
    end),
  })
end)
